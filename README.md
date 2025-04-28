# Overview

## Task1: Custom Command ( mygrep.sh )

mygrep.sh is a simple Bash script that replicates basic grep functionality, supporting:
•	Case-insensitive string search

•	Line numbers (-n option)

•	Invert match (-v option)

•	Combined options like -vn and -nv

## Usage

    • ./mygrep.sh [OPTIONS] search_string filename


## Options

    •	-n : Show line numbers for matches.
    
    •	-v : Invert match (show lines that do not match).
    
    •	Combinations like -vn and -nv are supported.

 ## Reflective Section

#### 1- How Arguments and Options Are Handled
•	The script uses getopts to parse options -n, -v, and -h.

•	Internal flags (line_numbers, invert) are set based on options.

•	After parsing options, the script expects exactly two positional arguments:

   1-	Search pattern
 
   2- File name

•	Input validation checks if the correct number of arguments is provided and if the file exists.

•	The script reads the file line-by-line. 

•	Each line and the search pattern are converted to lowercase for case-insensitive comparison.

•	If -v is used, match results are inverted.

#### 2- If I Were to Support -i / -c / -l Options

• -`i` (ignore case): 

Instead of manually converting text to lowercase, I would modify the comparison to use a regex engine that supports case-insensitive matching like grep -i or add internal flags to skip lowercasing.

• `-c` (count matches):

I would introduce a counter to count the number of matched lines and print only the total after processing.

• `-l` (list filenames with matches):

I would track whether any match occurs and then output only the filename if matches are found.

• Regex Support:

Instead of using simple substring matching (pattern), I would switch to using Bash's regex match operator =~ or external tools like grep -E.

#### 3- What Was Hardest to Implement

Handling the invert match -v option correctly was the hardest part.

It required careful logic to ensure that:

•	Matching lines are skipped when inverted.

•	Non-matching lines are printed correctly. Combining this with case-insensitive matching added complexity. 

## ScreenShots
• Provided in `"grep-ScreenShots/"`



# Internal Dashboard Connectivity Troubleshooting

## Problem
Internal web dashboard (internal.example.com) became unreachable with "host not found" errors.

## Investigation Steps
Verify DNS Resolution: Compare lookups from /etc/resolv.conf vs. 8.8.8.8.
Diagnose Service Reachability: Confirm port 80/443 on resolved IP via ss, curl, or telnet.
Trace the Issue – List All Possible Causes
Local stub resolver misconfigured
DNS cache stale on client or resolver
Missing/incorrect A record in DNS zone
Firewall blocking HTTP(S) ports
Service bound only to localhost
Network route/gateway misconfiguration
Conflicting /etc/hosts entry
SELinux/AppArmor blocking connections

## Command Used
        dig internal.example.com
        dig @8.8.8.8 internal.example.com
        curl -v http://internal.example.com
        telnet internal.example.com
        sudo netstat -tuln | grep '80\|443'
        cat /etc/hosts
        cat /etc/resolv.conf
        nslookup internal.example.com
        nslookup internal.example.com 8.8.8.8
        ping internal.example.com

##Bonus
/etc/hosts override: echo "10.10.20.30 internal.example.com" | sudo tee -a /etc/hosts

Persist DNS via systemd-resolved: create /etc/systemd/resolved.conf.d/custom.conf with [Resolve]\nDNS=10.0.0.2 

10.0.0.3\nDomains=internal.example.com, then systemctl restart systemd-resolved.

Persist via NetworkManager: nmcli con mod \"Wired\" ipv4.dns \"10.0.0.2 10.0.0.3\" ipv4.ignore-auto-dns yes && nmcli con up \"Wired\"       
