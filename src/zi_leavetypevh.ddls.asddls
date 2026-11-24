@EndUserText.label: 'Leave Type VH (Hardcoded)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LeaveTypeVH
  as select from zleave_hdr
{
  key 'ANNUAL' as LeaveType,
      '年假'   as Description
}
where leave_uuid = leave_uuid
union all
select from zleave_hdr
{
  key 'SICK' as LeaveType,
      '病假' as Description
}
where leave_uuid = leave_uuid
union all
select from zleave_hdr
{
  key 'PERSONAL' as LeaveType,
      '事假'     as Description
}
where leave_uuid = leave_uuid
