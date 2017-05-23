#!/usr/bin/awk -f
BEGIN {
 should_print=0;
}
{
    if ($0 ~ /\?xml/ ) should_print=1;
    gsub(/^[ \t]+/, "", $0)
    if ($0 ~ /<\/testsuite[s]?>/ ) {
        print $0;
        should_print=0;
    }
    if (should_print) print $0;
}
