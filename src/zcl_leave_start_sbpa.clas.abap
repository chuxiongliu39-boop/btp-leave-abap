CLASS zcl_leave_start_sbpa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CLASS-METHODS start_leave
      IMPORTING
        iv_applicant  TYPE string
        iv_start_date TYPE string
        iv_end_date   TYPE string
        iv_leave_days TYPE string
        iv_leave_type TYPE string
        iv_reason     TYPE string
      EXPORTING
        ev_status TYPE i
      RAISING
        cx_root.

  PRIVATE SECTION.
    CONSTANTS gc_token_url TYPE string VALUE 'https://12b35566trial.authentication.ap21.hana.ondemand.com/oauth/token'.
    CONSTANTS gc_client_id TYPE string VALUE 'sb-8b58b9d4-c922-4da3-af7b-9affd77b3bb7!b147751|xsuaa!b34447'.
    CONSTANTS gc_client_secret TYPE string VALUE '559d845b-32ca-40d1-b69e-40a8cef437a3$QbVY1GkTWqPJhHxVpDpq8me6j29Xry0-rnVKY24NAMU='.
    CONSTANTS gc_api_key TYPE string VALUE '7-kr4h9iquuIli-ToZPIY9RKwzSs2ATV'.
    CONSTANTS gc_api_host TYPE string VALUE 'https://spa-api-gateway-bpi-ap-prod.cfapps.ap21.hana.ondemand.com'.
    CONSTANTS gc_api_path TYPE string VALUE '/public/workflow/rest/v1/workflow-instances'.
    CONSTANTS gc_definition_id TYPE string VALUE 'ap21.12b35566trial.leaveapprove.leaveApprovalAPI'.

    CLASS-METHODS get_token
      EXPORTING
        ev_token TYPE string
      RAISING
        cx_root.

    CLASS-METHODS post_workflow
      IMPORTING
        iv_token      TYPE string
        iv_applicant  TYPE string
        iv_start_date TYPE string
        iv_end_date   TYPE string
        iv_leave_days TYPE string
        iv_leave_type TYPE string
        iv_reason     TYPE string
      EXPORTING
        ev_status TYPE i
        ev_body   TYPE string
      RAISING
        cx_root.

ENDCLASS.



CLASS ZCL_LEAVE_START_SBPA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA lv_token TYPE string.
    DATA lv_code  TYPE i.
    DATA lv_body  TYPE string.

    TRY.
        get_token( IMPORTING ev_token = lv_token ).
        post_workflow(
          EXPORTING
            iv_token      = lv_token
            iv_applicant  = 'ZZ0069'
            iv_start_date = '2026-10-21'
            iv_end_date   = '2026-10-23'
            iv_leave_days = '2'
            iv_leave_type = 'ANNUAL'
            iv_reason     = 'Mode B'
          IMPORTING
            ev_status = lv_code
            ev_body   = lv_body ).
        out->write( |HTTP status = { lv_code }| ).
        out->write( lv_body ).
      CATCH cx_root INTO DATA(lx).
        out->write( lx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.


  METHOD start_leave.
    DATA lv_token TYPE string.
    get_token( IMPORTING ev_token = lv_token ).
    post_workflow(
      EXPORTING
        iv_token      = lv_token
        iv_applicant  = iv_applicant
        iv_start_date = iv_start_date
        iv_end_date   = iv_end_date
        iv_leave_days = iv_leave_days
        iv_leave_type = iv_leave_type
        iv_reason     = iv_reason
      IMPORTING
        ev_status = ev_status ).
  ENDMETHOD.


  METHOD get_token.
    DATA(lo_dest) = cl_http_destination_provider=>create_by_url( i_url = gc_token_url ).
    DATA(lo_cli)  = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_dest ).
    DATA(lo_req)  = lo_cli->get_http_request( ).

    lo_req->set_authorization_basic(
      i_username = gc_client_id
      i_password = gc_client_secret ).
    lo_req->set_content_type( 'application/x-www-form-urlencoded' ).
    lo_req->set_text( 'grant_type=client_credentials' ).

    DATA(lo_res)  = lo_cli->execute( i_method = if_web_http_client=>post ).
    DATA(lv_json) = lo_res->get_text( ).

    IF lo_res->get_status( )-code <> 200.
      RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
    ENDIF.

    DATA(lv_marker) = |"access_token":"|.
    DATA(lv_pos) = find( val = lv_json sub = lv_marker ).
    IF lv_pos < 0.
      RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
    ENDIF.

    DATA(lv_start) = lv_pos + strlen( lv_marker ).
    DATA(lv_end)   = find( val = lv_json sub = |"| off = lv_start ).
    ev_token = substring( val = lv_json off = lv_start len = lv_end - lv_start ).
  ENDMETHOD.


  METHOD post_workflow.
    DATA(lo_dest) = cl_http_destination_provider=>create_by_url( i_url = gc_api_host ).
    DATA(lo_cli)  = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_dest ).
    DATA(lo_req)  = lo_cli->get_http_request( ).

    lo_req->set_uri_path( i_uri_path = gc_api_path ).
    lo_req->set_header_field( i_name = 'Authorization' i_value = |Bearer { iv_token }| ).
    lo_req->set_header_field( i_name = 'api-key' i_value = gc_api_key ).
    lo_req->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).

    DATA(lv_body) =
      |\{"definitionId":"{ gc_definition_id }",| &&
      |"context":\{| &&
      |"applicant":"{ iv_applicant }",| &&
      |"startDate":"{ iv_start_date }",| &&
      |"endDate":"{ iv_end_date }",| &&
      |"leaveDays":{ iv_leave_days },| &&
      |"leaveType":"{ iv_leave_type }",| &&
      |"reason":"{ iv_reason }"\}\}|.

    lo_req->set_text( lv_body ).

    DATA(lo_res) = lo_cli->execute( i_method = if_web_http_client=>post ).
    ev_status = lo_res->get_status( )-code.
    ev_body   = lo_res->get_text( ).
  ENDMETHOD.
ENDCLASS.
