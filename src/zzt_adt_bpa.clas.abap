CLASS zzt_adt_bpa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZZT_ADT_BPA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

TRY.
    DATA(lo_dest) = cl_http_destination_provider=>create_by_cloud_destination(
                      i_name = 'SBPAWF' ).
  CATCH cx_http_dest_provider_error INTO DATA(lx).
    " 看 lx->get_text( ) 或 lx->get_longtext( )
    RETURN.
ENDTRY.
DATA(lo_http) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
DATA(lo_req)  = lo_http->get_http_request( ).
lo_req->set_uri_path( '/public/workflow/rest/v1/workflow-instances' ).
lo_req->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
lo_req->set_header_field( i_name = 'api-key' i_value = '7-kr4h9iquuIli-ToZPIY9RKwzSs2ATV' ). " 练习用；正式勿写死
lo_req->set_text(
  |\{"definitionId":"ap21.12b35566trial.leaveapprove.leaveApprovalAPI",| &&
  |"context":\{"applicant":"ZZ0069","startDate":"2026-10-20",| &&
  |"endDate":"2026-10-22","leaveDays":2,"leaveType":"ANNUAL",| &&
  |"reason":"from ABAP"\}\}| ).
DATA(lo_res) = lo_http->execute( i_method = if_web_http_client=>post ).
DATA(lv_code) = lo_res->get_status( )-code.
DATA(lv_body) = lo_res->get_text( ).
" lv_code = 201 即成功；Monitor / Inbox 应有新实例

  ENDMETHOD.
ENDCLASS.
