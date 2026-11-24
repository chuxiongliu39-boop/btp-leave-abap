@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Item'
@Metadata.allowExtensions: true
define view entity ZZC_LEAVE_ITEM
  as projection on ZZR_LEAVE_ITEM
{
  key ItemUuid,
      LeaveUuid,
      ItemNo,
      Description,

      _LeaveHdr : redirected to parent ZZC_LEAVE_HDR
}
