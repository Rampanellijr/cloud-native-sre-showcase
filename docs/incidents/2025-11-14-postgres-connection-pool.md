# Incident Post-Mortem: Production Database Connection Exhaustion
**Date:** 2025-11-14  
**Status:** Resolved  
**Severity:** SEV-1 (High Impact)  
**Authors:** Luiz Rampanelli (SRE Lead)

## Summary
On November 14th at 14:30 UTC, the `payment-service` experienced a 45-minute outage, returning `503 Service Unavailable` errors to 15% of global users. The root cause was the exhaustion of PostgreSQL connection slots due to a misconfiguration in the connection pooling strategy during a traffic spike.

## Impact
* **Duration:** 45 minutes (14:30 - 15:15 UTC).
* **User Impact:** 15% of write requests failed. Read requests remained stable due to read-replicas.
* **Revenue Impact:** Estimated loss of transactional throughput during the window.

## Root Cause Analysis (RCA)
The application was deployed with a default generic connection pool size (10 connections per pod). During a scheduled marketing campaign, the Horizontal Pod Autoscaler (HPA) scaled the application from 20 to 100 pods.
* **Math:** 100 pods * 10 connections = 1,000 concurrent connections.
* **Constraint:** The RDS instance (`db.t3.large`) had a hard limit of `max_connections = 500`.
* **Result:** The database rejected new connections, causing the application to crash and restart in a loop (CrashLoopBackOff).

## Detection
* **14:30:** Prometheus alerted `HighErrorRate` (>5%) on Slack channel `#ops-alerts`.
* **14:32:** SRE On-call acknowledged the alert via PagerDuty.
* **14:35:** Dashboard analysis showed `pg_stat_activity` count hitting the ceiling (500).

## Resolution
* **Immediate Fix:** Temporarily increased the RDS instance size to `db.m5.xlarge` to support more connections (Vertical Scaling).
* **Permanent Fix:** Implemented **PgBouncer** as a sidecar proxy to multiplex connections, reducing the load on the database by 90%.

## Action Items (Prevention)
| Action Item | Type | Owner | Priority |
| :--- | :--- | :--- | :--- |
| Implement PgBouncer sidecar in Helm Charts | Engineering | @devops-team | P0 |
| Add alert for `pg_connected_clients > 80%` | Observability | @sre-team | P1 |
| Create load test scenario simulating 5x traffic | QA | @qa-lead | P2 |