CLASS LHC_ZZR_LEAVE_HDR DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR LeaveHdr
        RESULT result,
      startSbpa FOR MODIFY
            keys FOR ACTION LeaveHdr~startSbpa RESULT result,
      CalculateLeaveDays FOR DETERMINE ON MODIFY
            keys FOR LeaveHdr~CalculateLeaveDays.

          METHODS ValidateDates FOR VALIDATE ON SAVE
            keys FOR LeaveHdr~ValidateDates.
ENDCLASS.

CLASS LHC_ZZR_LEAVE_HDR IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD startSbpa.
   READ ENTITIES OF zzr_leave_hdr IN LOCAL MODE
    ENTITY LeaveHdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_leave)
    FAILED failed.
  LOOP AT lt_leave ASSIGNING FIELD-SYMBOL(<leave>).
    TRY.
        DATA lv_http TYPE i.
zcl_leave_start_sbpa=>start_leave(
  EXPORTING
    iv_applicant  = CONV string( <leave>-Applicant )
    iv_start_date = |{ <leave>-StartDate DATE = ISO }|
    iv_end_date   = |{ <leave>-EndDate DATE = ISO }|
    iv_leave_days = |{ <leave>-LeaveDays }|
    iv_leave_type = CONV string( <leave>-LeaveType )
    iv_reason     = CONV string( <leave>-Reason )
    iv_approver   = CONV string( <leave>-Approver )
  IMPORTING
    ev_status = lv_http ).
        IF lv_http <> 201.
          CONTINUE.
        ENDIF.
      CATCH cx_root.
        CONTINUE.
    ENDTRY.
  ENDLOOP.
  READ ENTITIES OF zzr_leave_hdr IN LOCAL MODE
    ENTITY LeaveHdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).
  result = VALUE #( FOR <r> IN lt_result
                    ( %tky   = <r>-%tky
                      %param = <r> ) ).
  ENDMETHOD.

  METHOD CalculateLeaveDays.
  READ ENTITIES OF ZZR_LEAVE_HDR IN LOCAL MODE
    ENTITY LeaveHdr
      FIELDS ( StartDate EndDate LeaveDays )
      WITH CORRESPONDING #( keys )
    RESULT DATA(leaves).

  LOOP AT leaves ASSIGNING FIELD-SYMBOL(<leave>).
    IF <leave>-StartDate IS INITIAL OR <leave>-EndDate IS INITIAL.
      <leave>-LeaveDays = 0.
    ELSE.
      " 含首尾的简单天数；业务若按工作日另说
      <leave>-LeaveDays = <leave>-EndDate - <leave>-StartDate + 1.
    ENDIF.
  ENDLOOP.

  MODIFY ENTITIES OF ZZR_LEAVE_HDR IN LOCAL MODE
    ENTITY LeaveHdr
      UPDATE FIELDS ( LeaveDays )
      WITH VALUE #( FOR l IN leaves
        ( %tky = l-%tky LeaveDays = l-LeaveDays ) ).
  ENDMETHOD.

  METHOD ValidateDates.
  READ ENTITIES OF ZZR_LEAVE_HDR IN LOCAL MODE
    ENTITY LeaveHdr
      FIELDS ( StartDate EndDate )
      WITH CORRESPONDING #( keys )
    RESULT DATA(leaves).

  LOOP AT leaves INTO DATA(leave).
    IF leave-StartDate IS NOT INITIAL
       AND leave-EndDate IS NOT INITIAL
       AND leave-EndDate < leave-StartDate.

      APPEND VALUE #( %tky = leave-%tky ) TO failed-LeaveHdr.

      APPEND VALUE #(
        %tky = leave-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'EndDate must be on or after StartDate' )
        %element-EndDate = if_abap_behv=>mk-on
      ) TO reported-LeaveHdr.
    ENDIF.
  ENDLOOP.
  ENDMETHOD.

ENDCLASS.
