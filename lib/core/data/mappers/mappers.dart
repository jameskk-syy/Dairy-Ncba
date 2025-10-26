import 'package:dairytenantapp/core/data/datasources/local/datasource/local/entity/routes_entity.dart';

import '../../domain/models/collector_routes_model.dart';

RoutesEntity fromDomain(CollectorRoutesEntityResponse response) {
  return RoutesEntity(
    id: response.id ?? 0,
    route: response.route ?? '',
    routeCode: response.routeCode ?? '',
    collectors: response.collectors ?? '',
  );
}

CollectorRoutesEntityResponse toRouteEntity(RoutesEntity entity) {
  return CollectorRoutesEntityResponse(
    id: entity.id,
    route: entity.route,
    routeCode: entity.routeCode,
    collectors: entity.collectors,
  );
}
