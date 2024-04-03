development:
  :concurrency: 5
production:
  :concurrency: 20
:queues:
  - default
  - mailers

:schedule: 
  :dynamic: true
  :dynamic_every: "5s"
