@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leave Item'
define view entity ZZR_LEAVE_ITEM
  as select from zleave_item
  association to parent ZZR_LEAVE_HDR as _LeaveHdr
    on $projection.LeaveUuid = _LeaveHdr.LeaveUUID
{
  key item_uuid     as ItemUuid,
      leave_uuid   as LeaveUuid,
      item_no       as ItemNo,
      description   as Description,
      _LeaveHdr
}
