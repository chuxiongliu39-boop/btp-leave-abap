@EndUserText.label: 'Leave Type VH (Domain)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZI_LeaveTypeVH_Dom
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_LEAVE_TYPE' )
{
  key value_low as LeaveType,
      text      as Description
}
where language = $session.system_language
