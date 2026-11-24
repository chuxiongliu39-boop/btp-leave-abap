@EndUserText.label: 'Leave Type VH Dependent'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LeaveTypeVH_Dep
  as select from zleave_type_dep
{
  key leave_type     as LeaveType,
      leave_category as LeaveCategory,
      description    as Description
}
