import 'package:social_cv_api/social_cv_api.dart';

class Part extends BaseManagedObject<_Part> implements _Part {}

@Table(name: 'parts')
class _Part extends BaseTableDefinition {
  @primaryKey
  int id;

  @Column(name:'tags')
  Document tags;

  ManagedSet<ProfilePartJoin> profilesParts;

  ManagedSet<PartGroupJoin> partsGroups;

  @Column(name:'type')
  String type;

  @Relate(#parts)
  User owner;
}