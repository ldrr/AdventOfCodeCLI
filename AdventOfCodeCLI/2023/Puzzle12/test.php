<?php

memory_reset_peak_usage();
$start_time = microtime(true);

$lines = file_get_contents("data.txt");
$lines = explode("\n", trim($lines));

function f($S, $G, $state, &$cache = [])
{
    $state_key = implode(":", $state);
    if (isset($cache[$state_key])) return $cache[$state_key];

    [$_s, $_g, $len] = $state;

    // print("\n$_s == ".strlen($S));

    if ($_s == strlen($S)) //...end of springs
    {       
        if(isset($G[$_g])) {
            print("\nEnd of spring $_g ".count($G)." $len ".$G[$_g]);
        } else {
            print("\nEnd of spring $_g ".count($G)." $len nil");
        }

        if ($_g == count($G)-1 && $len == $G[$_g]) { $_g++; $len = 0; }
        return (int)($_g == count($G) && $len == 0);
    }

    $result = 0;
    
    if (str_contains(".?", $S[$_s])) // ...operational
    {
        if ($len == 0)
            $result += f($S, $G, [$_s + 1, $_g, 0], $cache);
        elseif ($_g < count($G) && $G[$_g] == $len)
            $result += f($S, $G, [$_s + 1, $_g + 1, 0], $cache);
    }

    if (str_contains("#?", $S[$_s])) // ...damaged
    {
        // starting or continuing a group...
        $result += f($S, $G, [$_s + 1, $_g, $len + 1], $cache);
    }

    return $cache[$state_key] = $result;
}

$part1 = $part2 = 0;
$result = f("?###????????", [3,2,1], [0,0,0]);
print($result);
die();

foreach ([2] as $part)
{
    foreach ($lines as $line)
    {
        [$springs, $groups] = explode(" ", $line);
        $groups = explode(',', $groups);

        if ($part == 2)
        {
            $springs = "{$springs}?{$springs}?{$springs}?{$springs}?{$springs}";
            $groups = array_merge($groups, $groups, $groups, $groups, $groups);
        }

        print($springs);
        $result = f($springs, $groups, [0, 0, 0]);
        if ($part == 1) $part1 += $result; else $part2 += $result;

        die();
    }
}

echo "part 1: {$part1}\n";
echo "part 2: {$part2}\n";

echo "Execution time: ".round(microtime(true) - $start_time, 4)." seconds\n";
echo "   Peak memory: ".round(memory_get_peak_usage()/pow(2, 20), 4), " MiB\n\n";
