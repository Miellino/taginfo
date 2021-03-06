#!/bin/sh
#
#  Taginfo Master DB
#
#  update.sh DIR
#

set -e

DIR=$1

DATECMD='date +%Y-%m-%dT%H:%M:%S'

if [ "x" = "x$DIR" ]; then
    echo "Usage: update.sh DIR"
    exit 1
fi

echo "`$DATECMD` Start master..."

EXEC_RUBY="$TAGINFO_RUBY"
if [ "x$EXEC_RUBY" = "x" ]; then
    EXEC_RUBY=ruby
fi
echo "Running with ruby set as '${EXEC_RUBY}'"

DATABASE=$DIR/taginfo-master.db

echo "`$DATECMD` Create search database..."

rm -f $DIR/taginfo-search.db
$EXEC_RUBY -pe "\$_.sub!(/__DIR__/, '$DIR')" search.sql | sqlite3 $DIR/taginfo-search.db

rm -f $DATABASE

sqlite3 $DATABASE <languages.sql
$EXEC_RUBY -pe "\$_.sub!(/__DIR__/, '$DIR')" master.sql | sqlite3 $DATABASE
$EXEC_RUBY -pe "\$_.sub!(/__DIR__/, '$DIR')" interesting_tags.sql | sqlite3 $DATABASE
$EXEC_RUBY -pe "\$_.sub!(/__DIR__/, '$DIR')" interesting_relation_types.sql | sqlite3 $DATABASE

echo "`$DATECMD` Done master."

