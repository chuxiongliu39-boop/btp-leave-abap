@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZZLEAVE_HDR'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZZC_LEAVE_HDR
  provider contract transactional_query
  as projection on ZZR_LEAVE_HDR
  association [1..1] to ZZR_LEAVE_HDR as _BaseEntity on $projection.LeaveUUID = _BaseEntity.LeaveUUID
{
//  @UI.identification: [
//    { type: #FOR_ACTION, dataAction: 'startSbpa', label: 'Start SBPA' }
//  ]
  key LeaveUUID,
  LeaveID,
  
  Applicant,
  ApplicantName,
  StartDate,
  EndDate,
  LeaveDays,
  
  LeaveCategory,
//  @Consumption.valueHelpDefinition: [{
//  entity: { name: 'ZI_LeaveTypeVH_Dom', element: 'LeaveType' }
//}]
// @Consumption.valueHelpDefinition: [{
//  entity: { name: 'ZI_LeaveTypeVH', element: 'LeaveType' }
//}]

  LeaveType,
  Reason,
  Status,
  Approver,
  @Semantics: {
    user.createdBy: true
  }
  CreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  CreatedAt,
  @Semantics: {
    user.lastChangedBy: true
  }
  LastChangedBy,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  _LeaveItem : redirected to composition child ZZC_LEAVE_ITEM
//  _BaseEntity
}
