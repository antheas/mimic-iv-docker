Processed dataset information goes here.
Simlink it to place it somewhere else (assumes ~/data is mounted to a large drive):
```
ln -s ~/data/transforms/mimic-db data/transforms/mimic-db
```
Or, mount a RAM disk (assuming you have 100GB ram to spare...):
```
sudo mount -t tmpfs -o size=100G tmpfs data/transforms/mimic-db
```