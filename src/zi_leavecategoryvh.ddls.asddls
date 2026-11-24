@EndUserText.label: 'Leave Category VH'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_LeaveCategoryVH
  as select from zleave_category
{
  key leave_category as LeaveCategory,
      description    as Description
}
