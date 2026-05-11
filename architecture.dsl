workspace "Railway Journey Management System" "C4 Context, Container and Component Diagrams" {
    model {
        // People
        passenger = person "Passenger" "Searches connections, buys tickets and manages journeys."
        conductor = person "Conductor" "Validates tickets during inspection."
        trafficManager = person "Traffic Manager" "Manages timetable changes and disruptions."
        administrator = person "Administrator" "Creates conductor accounts and manages access."

        // External systems
        oauth = softwareSystem "OAuth 2.0 Provider" "Handles authentication." "External System"
        payU = softwareSystem "PayU" "Processes online payments and refunds." "External System"
        trainData = softwareSystem "Train Data Source" "Provides train position and delay data." "External System"

        // Our system
        railwaySystem = softwareSystem "Railway Journey Management System" "Supports timetable management, ticket sales, seat selection, ticket control and delay handling." {
            passengerApp = container "Passenger App" "Web/mobile application for passengers." "Web / Mobile App"
            conductorApp = container "Conductor App" "Mobile application for ticket inspection." "Mobile App"
            managementPanel = container "Management Panel" "Web panel for traffic managers and administrators." "Web App"

            apiGateway = container "API Gateway" "Single entry point for client applications." "Python / Go"
            messageBus = container "Message Bus" "Asynchronous communication bus used by all microservices." "Event Bus"

            authService = container "Auth Service" "Handles login, roles, conductor account creation and activation." "Microservice" {
                tags "Microservice"
            }

            scheduleService = container "Schedule Service" "Handles routes, timetables, seat maps and schedule changes." "Microservice" {
                tags "Microservice"
            }

            bookingService = container "Booking Service" "Handles reservations, ticket purchase and ticket generation." "Microservice" {
                tags "Microservice"

                bookingApi = component "Booking API" "Receives booking-related requests from the API Gateway." "Component"
                reservationManager = component "Reservation Manager" "Creates reservations and manages seat holds." "Component"
                ticketGenerator = component "Ticket Generator" "Generates electronic tickets." "Component"
                bookingEventPublisher = component "Booking Event Publisher" "Publishes booking and booking-status events to the Message Bus." "Component"
                bookingRepository = component "Booking Repository" "Persists reservations, tickets and payment status references." "Component"
            }

            paymentService = container "Payment Service" "Handles payment initiation, payment status updates and refunds as an abstraction over PayU." "Microservice" {
                tags "Microservice"
            }

            inspectionService = container "Inspection Service" "Handles QR validation, ticket status checks, inspection history and control reports." "Microservice" {
                tags "Microservice"
            }

            disruptionService = container "Disruption Service" "Handles delays, affected reservations and passenger journey change decisions." "Microservice" {
                tags "Microservice"
            }

            authDb = container "Auth DB" "Stores users, roles and activation data." "PostgreSQL" {
                tags "Database"
            }

            scheduleDb = container "Schedule DB" "Stores routes, timetables and seat maps." "PostgreSQL" {
                tags "Database"
            }

            bookingDb = container "Booking DB" "Stores reservations, tickets and payment status references." "PostgreSQL" {
                tags "Database"
            }

            paymentDb = container "Payment DB" "Stores payment requests, transaction statuses and refund records." "PostgreSQL" {
                tags "Database"
            }

            inspectionDb = container "Inspection DB" "Stores inspection results, reports and control history." "PostgreSQL" {
                tags "Database"
            }

            disruptionDb = container "Disruption DB" "Stores delays, affected journeys and passenger decisions." "PostgreSQL" {
                tags "Database"
            }
        }

        // C1 relationships
        passenger -> railwaySystem "Buys tickets and manages journeys"
        conductor -> railwaySystem "Validates tickets"
        trafficManager -> railwaySystem "Manages timetable changes"
        administrator -> railwaySystem "Manages conductor accounts"

        railwaySystem -> oauth "Authenticates users via"
        railwaySystem -> payU "Processes payments via"
        railwaySystem -> trainData "Reads delay data from"

        // C2 relationships
        passenger -> passengerApp "Uses"
        conductor -> conductorApp "Uses"
        trafficManager -> managementPanel "Uses"
        administrator -> managementPanel "Uses"

        passengerApp -> apiGateway "Calls"
        conductorApp -> apiGateway "Calls"
        managementPanel -> apiGateway "Calls"

        apiGateway -> authService "Routes authentication requests to"
        apiGateway -> scheduleService "Routes timetable requests to"
        apiGateway -> bookingService "Routes booking requests to"
        apiGateway -> paymentService "Routes payment requests to"
        apiGateway -> inspectionService "Routes inspection requests to"
        apiGateway -> disruptionService "Routes disruption requests to"

        authService -> messageBus "Publishes/subscribes via"
        scheduleService -> messageBus "Publishes/subscribes via"
        bookingService -> messageBus "Publishes/subscribes via"
        paymentService -> messageBus "Publishes/subscribes via"
        inspectionService -> messageBus "Publishes/subscribes via"
        disruptionService -> messageBus "Publishes/subscribes via"

        authService -> authDb "Reads from and writes to"
        scheduleService -> scheduleDb "Reads from and writes to"
        bookingService -> bookingDb "Reads from and writes to"
        paymentService -> paymentDb "Reads from and writes to"
        inspectionService -> inspectionDb "Reads from and writes to"
        disruptionService -> disruptionDb "Reads from and writes to"

        authService -> oauth "Authenticates via"
        bookingService -> paymentService "Requests payment initiation and refund handling from"
        paymentService -> payU "Processes payments and refunds via"
        disruptionService -> trainData "Reads delay data from"

        // C3 relationships - Booking Service
        apiGateway -> bookingApi "Calls"
        bookingApi -> reservationManager "Invokes"
        reservationManager -> paymentService "Requests payment handling from"
        reservationManager -> ticketGenerator "Requests ticket generation from"
        reservationManager -> bookingEventPublisher "Publishes booking events through"
        reservationManager -> bookingRepository "Reads from and writes to"

        bookingEventPublisher -> messageBus "Publishes to"
        bookingRepository -> bookingDb "Reads from and writes to"
    }

    views {
        systemContext railwaySystem "SystemContext" "C4 Level 1 - System Context" {
            include passenger
            include conductor
            include trafficManager
            include administrator
            include railwaySystem
            include oauth
            include payU
            include trainData
            autoLayout lr
        }

        container railwaySystem "Containers" "C4 Level 2 - Container Diagram" {
            include passenger
            include conductor
            include trafficManager
            include administrator

            include passengerApp
            include conductorApp
            include managementPanel
            include apiGateway
            include messageBus

            include authService
            include scheduleService
            include bookingService
            include paymentService
            include inspectionService
            include disruptionService

            include authDb
            include scheduleDb
            include bookingDb
            include paymentDb
            include inspectionDb
            include disruptionDb

            include oauth
            include payU
            include trainData

            autoLayout lr
        }

        component bookingService "BookingServiceComponents" "C4 Level 3 - Components of Booking Service" {
            include apiGateway

            include bookingApi
            include reservationManager
            include ticketGenerator
            include bookingEventPublisher
            include bookingRepository

            include bookingDb
            include messageBus
            include paymentService

            autoLayout lr
        }

        styles {
            element "Person" {
                shape Person
                background #08427B
                color #ffffff
                fontSize 22
            }

            element "Software System" {
                background #1168BD
                color #ffffff
            }

            element "External System" {
                background #999999
                color #ffffff
            }

            element "Container" {
                background #438DD5
                color #ffffff
            }

            element "Component" {
                background #85BBF0
                color #000000
            }

            element "Microservice" {
                shape Hexagon
                background #4E79A7
                color #ffffff
                stroke #2F5B85
            }

            element "Database" {
                shape Cylinder
                background #59A14F
                color #ffffff
                stroke #3D7A36
            }
        }

        themes default
    }
}
