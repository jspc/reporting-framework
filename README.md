Rationale
--

Inefficiency and repetitiveness are things which must not be tolerated.


Usage
--

Currently running `bin/reports.rb` takes a report to run and a list of games. The report is a useless trigger for now.

Run as per:

```bash
17:05 pm jspc@egg.zero-internet.org.uk :: ~/projects/reporting-framework $(master) ./bin/reports.rb --help
Usage: ./bin/reports.rb [options]
    -g, --games [FILE]               Games File
    -r, --report [REPORT]            Report to run
```


Writing Reports
--

In the dir `lib/reporting/` the code to generate a report runs. A report **must** expose the public method `get_report( db, games_list )`
and must return a report of some kind. Preferably by STDOUT.


Populating The Database
--

We use redis which, whilst ostensibly schemaless, follows the non-enforced schema:

```ruby
watchlist
watchlist.runtimes              # List of timestamps as per %Y-%m%d %H:%M
watchlist.#{game}.#{time}.mua   # MUA for apps
watchlist.#{game}.#{time}.dua   # DUA for apps
```

This is filled by the script `bin/populate_db.rb` which should be run as a cronjob. Adding metrics to it would be a piece of piss.
