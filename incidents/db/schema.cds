using { cuid, managed, sap.common.CodeList } from '@sap/cds/common';

namespace acme.incmgt;

/**
 * Incidents created by Customers.
 */
entity Incidents : cuid, managed {
  title        : String  @title : 'Title';
  urgency      : Urgency @title : 'Urgency';
  status       : Status  @title : 'Status';
  conversation : Composition of many {
    key timestamp : DateTime    @title: 'Time';
    author        : String(77)  @title: 'Author' @cds.on.create: $user;
    message       : String(300) @title: 'Message';
  };
  service      : Association to Appointments;
}

type Urgency : Association to Urgencies;
entity Urgencies : CodeList {
  key code : String @title: 'Urgency';
}

type Status : Association to Statuses;
entity Statuses : CodeList {
  key code : String @title: 'Status';
}


/**
 * Service Workers to assign to fix the causes for Incidents
 */
entity ServiceWorkers {
  key ID       : String; // human-readable ID, like SAP's D/C/I numbers
  name         : String;
  role         : String;
  appointments : Association to many Appointments on appointments.worker = $self;
}

/**
 * All the Appointments of Service Workers.
 * Used to find availabilities in a worker's calendar to block
 * for fixing the causes for an Incident, which in turn would
 * be entered as a new Appointment.
 */
entity Appointments {
  key ID     : String;
  start_date : Date    @title : 'Start Date';
  start_time : Time    @title : 'Start Time';
  end_date   : Date    @title : 'End Date';
  end_time   : Time    @title : 'End Time';
  title      : String  @title : 'Title';
  project    : String  @title : 'Project';
  type       : String  @title : 'Type';
  calendar   : Association to TeamCalendar;
  worker     : Association to ServiceWorkers;
}

/**
 * Team Calendars of service units aggregating all Appointments of
 * all Service Workes in that unit per year.
 */
entity TeamCalendar {
  key year : Integer;
  entries  : Composition of many Appointments on entries.calendar = $self;
}


type EMailAddress : String;
type PhoneNumber : String;
type City : String;