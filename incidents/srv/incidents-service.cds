using { acme.incmgt } from '../db/schema';
using { sap.attachments.Attachments } from 'com.sap.cds/cds-feature-attachments';

extend incmgt.Incidents with {
  attachments : composition of many Attachments;
}

service IncidentsService {
  entity Incidents      as projection on incmgt.Incidents;
  entity Appointments   as projection on incmgt.Appointments;
  entity ServiceWorkers as projection on incmgt.ServiceWorkers;
}
