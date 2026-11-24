@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZZLEAVE_HDR'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZZR_LEAVE_HDR
  as select from zleave_hdr as LeaveHdr
  composition [0..*] of ZZR_LEAVE_ITEM as _LeaveItem
{
  key leave_uuid as LeaveUUID,
  leave_id as LeaveID,
  applicant as Applicant,
  applicant_name as ApplicantName,
  start_date as StartDate,
  end_date as EndDate,
  leave_days as LeaveDays,
  leave_category as LeaveCategory,
  leave_type as LeaveType,
  reason as Reason,
  status as Status,
  approver as Approver,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  _LeaveItem
}
