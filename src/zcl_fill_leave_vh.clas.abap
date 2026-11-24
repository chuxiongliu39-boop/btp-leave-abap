CLASS zcl_fill_leave_vh DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS ZCL_FILL_LEAVE_VH IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DELETE FROM zleave_type_dep.      " 可重复执行时先清（按需）
    DELETE FROM zleave_category.

    INSERT zleave_category FROM TABLE @( VALUE #(
      ( leave_category = 'WORK' description = '因公相关' )
      ( leave_category = 'PERS' description = '个人假期' )
    ) ).

    INSERT zleave_type_dep FROM TABLE @( VALUE #(
      ( leave_type = 'ANNUAL' leave_category = 'WORK' description = '年假' )
      ( leave_type = 'SICK'   leave_category = 'PERS' description = '病假' )
      ( leave_type = 'PERSON' leave_category = 'PERS' description = '事假' )
    ) ).

    COMMIT WORK.

    out->write( |category={ sy-dbcnt } types inserted| ).
  ENDMETHOD.
ENDCLASS.
