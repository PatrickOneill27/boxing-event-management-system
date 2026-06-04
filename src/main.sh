#!/bin/bash
# ==========================
# File Locations
# ==========================
MEMBERS_FILE="../data/members.csv"
EVENTS_FILE="../data/events.csv"
FIGHTS_FILE="../data/fights.csv"

# ==========================
# Helper Functions
# ==========================

# File Initialisation
init_files() {
    mkdir -p ../data
    [[ -f "$MEMBERS_FILE" ]] || echo "ID,Name,Phone,Email,Weightclass,Role,Notes" > "$MEMBERS_FILE"
    [[ -f "$FIGHTS_FILE" ]] || echo "FID,EID,RedID,BlueID,Weightclass,Status" > "$FIGHTS_FILE"
    [[ -f "$EVENTS_FILE" ]] || echo "EID,Event,Date,Venue" > "$EVENTS_FILE"
}

# Pause
pause() {
    echo
    read -rp "Press Enter to continue..."
}

# Navigation Hint
show_nav_hint() {
    echo
    echo "-----------------------------------"
    echo "[M] Back to Menu"
    echo "-----------------------------------"
    echo
}

# ==========================
# Display Helpers
# ==========================

display_member_rows() {
    if command -v column >/dev/null 2>&1; then
        {
            echo "ID,Name,Phone,Email,Weightclass,Notes"
            if [[ -n "$1" ]]; then
                echo "$1" | awk -F, 'BEGIN {OFS=","} {print $1,$2,$3,$4,$5,$7}'
            else
                awk -F, 'NR>1 {OFS=","; print $1,$2,$3,$4,$5,$7}' "$MEMBERS_FILE"
            fi
        } | column -t -s,
    else
        {
            echo "ID,Name,Phone,Email,Weightclass,Notes"
            if [[ -n "$1" ]]; then
                echo "$1" | awk -F, 'BEGIN {OFS=","} {print $1,$2,$3,$4,$5,$7}'
            else
                awk -F, 'NR>1 {OFS=","; print $1,$2,$3,$4,$5,$7}' "$MEMBERS_FILE"
            fi
        }
    fi
}

display_boxer_rows() {
    if command -v column >/dev/null 2>&1; then
        {
            echo "ID,Name,Weightclass"
            awk -F, 'NR>1 && tolower($6)=="boxer" {print $1 "," $2 "," $5}' "$MEMBERS_FILE"
        } | column -t -s,
    else
        {
            echo "ID,Name,Weightclass"
            awk -F, 'NR>1 && tolower($6)=="boxer" {print $1 "," $2 "," $5}' "$MEMBERS_FILE"
        }
    fi
}

display_fight_rows() {
    if command -v column >/dev/null 2>&1; then
        {
            echo "FightID,Event,Date,Venue,Red Corner,Blue Corner,Weightclass,Status"

            if [[ -n "$1" ]]; then
                echo "$1" | while IFS=, read -r fid eid red_id blue_id wc status; do
                    eid=$(printf '%s' "$eid" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    red_id=$(printf '%s' "$red_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    blue_id=$(printf '%s' "$blue_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

                    event_name=$(get_event_name_by_id "$eid")
                    event_date=$(get_event_date_by_id "$eid")
                    event_venue=$(get_event_venue_by_id "$eid")
                    red_name=$(get_boxer_name_by_id "$red_id")
                    blue_name=$(get_boxer_name_by_id "$blue_id")

                    echo "$fid,$event_name,$event_date,$event_venue,$red_name,$blue_name,$wc,$status"
                done
            else
                awk -F, 'NR>1 {print $1 "," $2 "," $3 "," $4 "," $5 "," $6}' "$FIGHTS_FILE" |
                while IFS=, read -r fid eid red_id blue_id wc status; do
                    eid=$(printf '%s' "$eid" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    red_id=$(printf '%s' "$red_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    blue_id=$(printf '%s' "$blue_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

                    event_name=$(get_event_name_by_id "$eid")
                    event_date=$(get_event_date_by_id "$eid")
                    event_venue=$(get_event_venue_by_id "$eid")
                    red_name=$(get_boxer_name_by_id "$red_id")
                    blue_name=$(get_boxer_name_by_id "$blue_id")

                    echo "$fid,$event_name,$event_date,$event_venue,$red_name,$blue_name,$wc,$status"
                done
            fi
        } | column -t -s,
    else
        echo "FightID,Event,Date,Venue,Red Corner,Blue Corner,Weightclass,Status"

        if [[ -n "$1" ]]; then
            echo "$1" | while IFS=, read -r fid eid red_id blue_id wc status; do
                eid=$(printf '%s' "$eid" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                red_id=$(printf '%s' "$red_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                blue_id=$(printf '%s' "$blue_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

                event_name=$(get_event_name_by_id "$eid")
                event_date=$(get_event_date_by_id "$eid")
                event_venue=$(get_event_venue_by_id "$eid")
                red_name=$(get_boxer_name_by_id "$red_id")
                blue_name=$(get_boxer_name_by_id "$blue_id")

                echo "$fid,$event_name,$event_date,$event_venue,$red_name,$blue_name,$wc,$status"
            done
        else
            awk -F, 'NR>1 {print $1 "," $2 "," $3 "," $4 "," $5 "," $6}' "$FIGHTS_FILE" |
            while IFS=, read -r fid eid red_id blue_id wc status; do
                eid=$(printf '%s' "$eid" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                red_id=$(printf '%s' "$red_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                blue_id=$(printf '%s' "$blue_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

                event_name=$(get_event_name_by_id "$eid")
                event_date=$(get_event_date_by_id "$eid")
                event_venue=$(get_event_venue_by_id "$eid")
                red_name=$(get_boxer_name_by_id "$red_id")
                blue_name=$(get_boxer_name_by_id "$blue_id")

                echo "$fid,$event_name,$event_date,$event_venue,$red_name,$blue_name,$wc,$status"
            done
        fi
    fi
}

# ==========================
# Validation
# ==========================
is_blank() { [[ -z "${1// }" ]]; }
valid_phone() { [[ "$1" =~ ^[0-9]{10}$ ]]; }
valid_email() { [[ "$1" =~ ^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$ ]]; }

valid_date() {
    if [[ "$1" =~ ^([0-2][0-9]|3[0-1])-([0][1-9]|1[0-2])-[0-9]{4}$ ]]; then
        return 0
    else
        return 1
    fi
}

valid_boxer() {
    awk -F, -v name="$1" 'tolower($2)==tolower(name) && tolower($6)=="boxer" {found=1} END {exit !found}' "$MEMBERS_FILE"
}

get_boxer_name_by_id() {
    local clean_id
    clean_id=$(printf '%s' "$1" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    awk -F, -v id="$clean_id" '
        NR>1 {
            member_id=$1
            role=$6
            gsub(/\r/, "", member_id)
            gsub(/\r/, "", role)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", member_id)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", role)

            if (member_id == id && tolower(role) == "boxer") {
                print $2
            }
        }
    ' "$MEMBERS_FILE"
}

get_boxer_weightclass_by_id() {
    local clean_id
    clean_id=$(printf '%s' "$1" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    awk -F, -v id="$clean_id" '
        NR>1 {
            member_id=$1
            role=$6
            gsub(/\r/, "", member_id)
            gsub(/\r/, "", role)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", member_id)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", role)

            if (member_id == id && tolower(role) == "boxer") {
                print $5
            }
        }
    ' "$MEMBERS_FILE"
}

fighter_booked_on_date() {
    local fighter_id="$1"
    local fight_date="$2"
    local exclude_fight_id="$3"

    while IFS=, read -r fid eid red_id blue_id wc status; do
        [[ "$fid" == "FID" ]] && continue
        [[ -n "$exclude_fight_id" && "$fid" == "$exclude_fight_id" ]] && continue

        event_date=$(get_event_date_by_id "$eid")

        if [[ "$event_date" == "$fight_date" && ( "$red_id" == "$fighter_id" || "$blue_id" == "$fighter_id" ) ]]; then
            return 0
        fi
    done < "$FIGHTS_FILE"

    return 1
}

member_has_linked_fights() {
    local member_id="$1"

    awk -F, -v id="$member_id" '
        NR>1 && ($3==id || $4==id) {found=1}
        END {exit !found}
    ' "$FIGHTS_FILE"
}

# ==========================
# Event Helpers
# ==========================
event_exists() {
    awk -F, -v id="$1" 'NR>1 && $1==id {found=1} END {exit !found}' "$EVENTS_FILE"
}

get_event_name_by_id() {
    awk -F, -v id="$1" 'NR>1 && $1==id {print $2}' "$EVENTS_FILE"
}

get_event_date_by_id() {
    awk -F, -v id="$1" 'NR>1 && $1==id {print $3}' "$EVENTS_FILE"
}

get_event_venue_by_id() {
    awk -F, -v id="$1" 'NR>1 && $1==id {print $4}' "$EVENTS_FILE"
}

generate_event_id() {
    last_id=$(tail -n 1 "$EVENTS_FILE" | awk -F, '{print $1}')

    if [[ "$last_id" == "EID" || -z "$last_id" ]]; then
        echo "E001"
    else
        last_num=${last_id#E}
        new_num=$((10#$last_num + 1))
        printf "E%03d\n" "$new_num"
    fi
}

# ==========================
# Exit
# ==========================
exit_program() {
    read -rp "Are you sure you want to exit? (Y/N): " ans
    case "${ans,,}" in
        y|yes)
            echo "Exiting system..."
            exit 0
            ;;
        *)
            echo "Returning to menu..."
            sleep 1
            ;;
    esac
}

# ==========================
# Weightclass
# ==========================
choose_weightclass() {
    weightclass=""
    echo
    echo "Weightclass:"
    echo "1) Flyweight"
    echo "2) Bantamweight"
    echo "3) Featherweight"
    echo "4) Lightweight"
    echo "5) Welterweight"
    echo "6) Middleweight"
    echo "7) Light Heavyweight"
    echo "8) Heavyweight"
    echo "M) Members Menu"
    echo

    read -rp "Choose (1-8 or M): " choice
    case "${choice,,}" in
        m) return 1 ;;
        1) weightclass="Flyweight" ;;
        2) weightclass="Bantamweight" ;;
        3) weightclass="Featherweight" ;;
        4) weightclass="Lightweight" ;;
        5) weightclass="Welterweight" ;;
        6) weightclass="Middleweight" ;;
        7) weightclass="Light Heavyweight" ;;
        8) weightclass="Heavyweight" ;;
        *) weightclass="" ;;
    esac
    return 0
}

# ==========================
# Members Menu
# ==========================
members_menu() {
    while true; do
        clear
        echo "==============================="
        echo "        Members Menu"
        echo "==============================="
        echo "1) Add Member"
        echo "2) Search Members"
        echo "3) View All Members"
        echo "4) Edit Member"
        echo "5) Remove Member(s)"
        echo "6) Back to Main Menu"
        echo
        read -rp "Choose an option: " opt

        case "$opt" in
            1) add_member ;;
            2) search_members ;;
            3) view_all_members ;;
            4) edit_member ;;
            5) remove_members ;;
            6) return ;;
            *) echo "Invalid option." ; sleep 1 ;;
        esac
    done
}

# ==========================
# Members Functions
# ==========================
add_member() {
    clear
    echo "=== Add Member ==="
    show_nav_hint

    while true; do
        read -rp "Name: " name
        if [[ "${name,,}" == "m" ]]; then return; fi
        if is_blank "$name"; then
            echo "Name cannot be blank."
        else
            break
        fi
    done

    while true; do
        read -rp "Phone (10 digits): " phone
        if [[ "${phone,,}" == "m" ]]; then return; fi
        if ! valid_phone "$phone"; then
            echo "Phone must be exactly 10 digits (e.g. 0871234567)."
        else
            break
        fi
    done

    while true; do
        read -rp "Email: " email
        if [[ "${email,,}" == "m" ]]; then return; fi
        if ! valid_email "$email"; then
            echo "Email must look like name@example.com."
        else
            break
        fi
    done

    while true; do
        echo
        echo "Role:"
        echo "1) Boxer"
        echo "2) Coach"
        echo "3) Staff"
        echo "M) Members Menu"
        read -rp "Choose: " r

        if [[ "${r,,}" == "m" ]]; then return; fi

        case "$r" in
            1) role="Boxer"; break ;;
            2) role="Coach"; break ;;
            3) role="Staff"; break ;;
            *) echo "Invalid choice. Pick 1-3." ;;
        esac
    done

    if [[ "$role" == "Boxer" ]]; then
        while true; do
            choose_weightclass
            if [[ $? -eq 1 ]]; then return; fi

            if is_blank "$weightclass"; then
                echo "Please choose a valid option (1-8)."
            else
                wc="$weightclass"
                break
            fi
        done
    else
        wc="N/A"
    fi

    read -rp "Notes (optional): " notes
    if [[ "${notes,,}" == "m" ]]; then return; fi

    if grep -qiE ",$phone,|,$email," "$MEMBERS_FILE"; then
        echo
        echo "Duplicate found: a member with this phone or email already exists."
        pause
        return
    fi

    last_id=$(tail -n 1 "$MEMBERS_FILE" | awk -F, '{print $1}')
    if [[ "$last_id" == "ID" || -z "$last_id" ]]; then
        new_id="0001"
    else
        new_num=$((10#$last_id + 1))
        printf -v new_id "%04d" "$new_num"
    fi

    echo
    echo "Please confirm:"
    echo "ID: $new_id"
    echo "Name: $name"
    echo "Phone: $phone"
    echo "Email: $email"
    echo "Weightclass: $wc"
    echo "Role: $role"
    echo "Notes: $notes"
    echo
    read -rp "Save this member? (Y/N): " confirm

    case "${confirm,,}" in
        y|yes)
            echo "$new_id,$name,$phone,$email,$wc,$role,$notes" >> "$MEMBERS_FILE"
            echo "Member saved."
            ;;
        *)
            echo "Cancelled. Nothing saved."
            ;;
    esac

    pause
}

search_members() {
    while true; do
        clear
        echo "=== Search Members ==="
        echo
        echo "1) Keyword Search"
        echo "2) Filter By Weightclass"
        echo "3) Filter By Role"
        echo "4) Back To Members Menu"
        echo
        read -rp "Choose an option: " opt

        case "$opt" in
            1)
                read -rp "Enter keyword to search (press Enter to go back): " keyword
                if is_blank "$keyword"; then
                    continue
                fi

                matches=$(awk -F, -v keyword="$keyword" '
                    NR>1 && tolower($0) ~ tolower(keyword)
                ' "$MEMBERS_FILE")

                echo
                if [[ -n "$matches" ]]; then
                    display_member_rows "$matches"
                else
                    echo "No matches found."
                fi
                pause
                ;;

            2)
                while true; do
                    choose_weightclass
                    if [[ $? -eq 1 ]]; then
                        break
                    fi

                    if is_blank "$weightclass"; then
                        echo "Please choose a valid option (1-8), or M to go back."
                        continue
                    fi

                    matches=$(awk -F, -v wc="$weightclass" 'NR>1 && $5==wc' "$MEMBERS_FILE")

                    echo
                    if [[ -n "$matches" ]]; then
                        display_member_rows "$matches"
                    else
                        echo "No members found in this weightclass."
                    fi
                    pause
                    break
                done
                ;;

            3)
                echo
                echo "1) Boxer"
                echo "2) Coach"
                echo "3) Staff"
                echo "M) Back To Members Menu"
                echo
                read -rp "Choose role: " r

                if [[ "${r,,}" == "m" ]]; then
                    continue
                fi

                case "$r" in
                    1) role="Boxer" ;;
                    2) role="Coach" ;;
                    3) role="Staff" ;;
                    *)
                        echo "Invalid option."
                        pause
                        continue
                        ;;
                esac

                matches=$(awk -F, -v role="$role" 'NR>1 && tolower($6)==tolower(role)' "$MEMBERS_FILE")

                echo
                if [[ -n "$matches" ]]; then
                    display_member_rows "$matches"
                else
                    echo "No members found with this role."
                fi
                pause
                ;;

            4)
                return
                ;;

            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

view_all_members() {
    clear
    echo "=== All Members ==="
    echo

    if [[ $(wc -l < "$MEMBERS_FILE") -le 1 ]]; then
        echo "No members found."
        pause
        return
    fi

    display_member_rows
    pause
}

edit_member() {
    while true; do
        clear
        echo "=== Edit Member ==="
        echo "Press Enter to keep current value."
        echo "Enter M at any prompt to go back."
        echo

        if [[ $(wc -l < "$MEMBERS_FILE") -le 1 ]]; then
            echo "No members found."
            pause
            return
        fi

        echo "Available Members:"
        display_member_rows
        echo

        read -rp "Enter Member ID to edit: " member_id
        if [[ "${member_id,,}" == "m" ]]; then return; fi

        if is_blank "$member_id"; then
            echo "Member ID cannot be blank."
            pause
            continue
        fi

        match=$(awk -F, -v id="$member_id" 'NR>1 && $1==id' "$MEMBERS_FILE")

        if [[ -z "$match" ]]; then
            echo "No member found with that ID."
            pause
            continue
        fi

        current_name=$(echo "$match" | awk -F, '{print $2}')
        current_phone=$(echo "$match" | awk -F, '{print $3}')
        current_email=$(echo "$match" | awk -F, '{print $4}')
        current_wc=$(echo "$match" | awk -F, '{print $5}')
        current_role=$(echo "$match" | awk -F, '{print $6}')
        current_notes=$(echo "$match" | awk -F, '{print $7}')

        echo
        echo "Current Member Details:"
        echo "Name:        $current_name"
        echo "Phone:       $current_phone"
        echo "Email:       $current_email"
        echo "Weightclass: $current_wc"
        echo "Role:        $current_role"
        echo "Notes:       $current_notes"
        echo

        read -rp "New Name [$current_name] (Enter = keep, M = back): " new_name
        if [[ "${new_name,,}" == "m" ]]; then return; fi
        [[ -z "$new_name" ]] && new_name="$current_name"

        if is_blank "$new_name"; then
            echo "Name cannot be blank."
            pause
            continue
        fi

        read -rp "New Phone [$current_phone] (Enter = keep, M = back): " new_phone
        if [[ "${new_phone,,}" == "m" ]]; then return; fi
        [[ -z "$new_phone" ]] && new_phone="$current_phone"

        if ! valid_phone "$new_phone"; then
            echo "Phone must be exactly 10 digits (e.g. 0871234567)."
            pause
            continue
        fi

        read -rp "New Email [$current_email] (Enter = keep, M = back): " new_email
        if [[ "${new_email,,}" == "m" ]]; then return; fi
        [[ -z "$new_email" ]] && new_email="$current_email"

        if ! valid_email "$new_email"; then
            echo "Email must look like name@example.com."
            pause
            continue
        fi

        echo
        echo "Role:"
        echo "1) Boxer"
        echo "2) Coach"
        echo "3) Staff"
        echo "4) Keep Current [$current_role]"
        echo "M) Back"
        read -rp "Choose: " r

        if [[ "${r,,}" == "m" ]]; then return; fi

        case "$r" in
            1) new_role="Boxer" ;;
            2) new_role="Coach" ;;
            3) new_role="Staff" ;;
            4|"") new_role="$current_role" ;;
            *)
                echo "Invalid choice."
                pause
                continue
                ;;
        esac

        if [[ "$current_role" == "Boxer" && "$new_role" != "Boxer" ]]; then
            if member_has_linked_fights "$member_id"; then
                echo "This member cannot be changed from Boxer to $new_role because they are linked to existing fights."
                echo "Remove or edit those fights first."
                pause
                continue
            fi
        fi

        if [[ "$new_role" == "Boxer" ]]; then
            if [[ "$current_role" == "Boxer" ]]; then
                echo
                echo "Current Weightclass: $current_wc"
                choose_weightclass
                if [[ $? -eq 1 ]]; then return; fi

                if is_blank "$weightclass"; then
                    echo "Keeping current weightclass: $current_wc"
                    new_wc="$current_wc"
                else
                    echo "New weightclass set: $weightclass"
                    new_wc="$weightclass"
                fi
            else
                while true; do
                    choose_weightclass
                    if [[ $? -eq 1 ]]; then return; fi

                    if is_blank "$weightclass"; then
                        echo "Please choose a valid option (1-8)."
                    else
                        new_wc="$weightclass"
                        break
                    fi
                done
            fi
        else
            new_wc="N/A"
        fi

        read -rp "New Notes [$current_notes] (Enter = keep, M = back): " new_notes
        if [[ "${new_notes,,}" == "m" ]]; then return; fi
        [[ -z "$new_notes" ]] && new_notes="$current_notes"

        if awk -F, -v id="$member_id" -v phone="$new_phone" -v email="$new_email" '
            BEGIN {IGNORECASE=1}
            NR>1 && $1!=id && ($3==phone || $4==email) {found=1}
            END {exit !found}
        ' "$MEMBERS_FILE"; then
            echo
            echo "Duplicate found: another member already has that phone or email."
            pause
            continue
        fi

        echo
        echo "Updated Member Details:"
        echo "ID:          $member_id"
        echo "Name:        $new_name"
        echo "Phone:       $new_phone"
        echo "Email:       $new_email"
        echo "Weightclass: $new_wc"
        echo "Role:        $new_role"
        echo "Notes:       $new_notes"
        echo

        read -rp "Save these changes? (Y/N or M to cancel): " confirm
        if [[ "${confirm,,}" == "m" ]]; then return; fi

        case "${confirm,,}" in
            y|yes)
                awk -F, -v id="$member_id" -v name="$new_name" -v phone="$new_phone" -v email="$new_email" -v wc="$new_wc" -v role="$new_role" -v notes="$new_notes" '
                    BEGIN {OFS=","}
                    NR==1 {print; next}
                    $1==id {$2=name; $3=phone; $4=email; $5=wc; $6=role; $7=notes}
                    {print}
                ' "$MEMBERS_FILE" > temp.csv
                mv temp.csv "$MEMBERS_FILE"
                echo "Member updated."
                pause
                return
                ;;
            *)
                echo "Edit cancelled."
                pause
                return
                ;;
        esac
    done
}

remove_members() {
    while true; do
        clear
        echo "=== Remove Members ==="
        echo
        echo "1) Remove one member by ID"
        echo "2) Remove multiple members by Role"
        echo "3) Back to Members Menu"
        echo
        read -rp "Choose an option: " opt

        case "$opt" in
            1)
                echo
                echo "Available Members:"
                if [[ $(wc -l < "$MEMBERS_FILE") -le 1 ]]; then
                    echo "No members found."
                    pause
                    continue
                fi

                display_member_rows

                echo
                read -rp "Enter Member ID to delete (or M to go back): " id
                if [[ "${id,,}" == "m" ]]; then
                    continue
                fi

                if is_blank "$id"; then
                    echo "Member ID cannot be blank."
                    pause
                    continue
                fi

                match=$(awk -F, -v id="$id" 'NR>1 && $1==id' "$MEMBERS_FILE")

                if [[ -z "$match" ]]; then
                    echo "No member found with that ID."
                    pause
                    continue
                fi

                echo
                echo "Member found:"
                display_member_rows "$match"
                echo

                read -rp "Are you sure you want to delete this member? (Y/N): " confirm
                case "${confirm,,}" in
                    y|yes)
                        awk -F, -v id="$id" 'NR==1 || $1!=id' "$MEMBERS_FILE" > temp.csv
                        mv temp.csv "$MEMBERS_FILE"
                        echo "Member deleted."
                        ;;
                    *)
                        echo "Deletion cancelled."
                        ;;
                esac
                pause
                ;;

            2)
                echo
                echo "1) Boxer"
                echo "2) Coach"
                echo "3) Staff"
                echo "M) Back to Remove Members Menu"
                echo
                read -rp "Choose role to delete: " r

                if [[ "${r,,}" == "m" ]]; then
                    continue
                fi

                case "$r" in
                    1) role="Boxer" ;;
                    2) role="Coach" ;;
                    3) role="Staff" ;;
                    *)
                        echo "Invalid option."
                        pause
                        continue
                        ;;
                esac

                matches=$(awk -F, -v role="$role" 'NR>1 && tolower($6)==tolower(role)' "$MEMBERS_FILE")

                if [[ -z "$matches" ]]; then
                    echo "No members found with role: $role"
                    pause
                    continue
                fi

                echo
                echo "The following members will be deleted:"
                display_member_rows "$matches"
                echo

                read -rp "Are you sure you want to delete ALL $role members? (Y/N): " confirm
                case "${confirm,,}" in
                    y|yes)
                        awk -F, -v role="$role" 'NR==1 || tolower($6)!=tolower(role)' "$MEMBERS_FILE" > temp.csv
                        mv temp.csv "$MEMBERS_FILE"
                        echo "All $role members deleted."
                        ;;
                    *)
                        echo "Deletion cancelled."
                        ;;
                esac
                pause
                ;;

            3)
                return
                ;;

            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

# ==========================
# Events Menu
# ==========================
events_menu() {
    while true; do
        clear
        echo "=== Events Menu ==="
        echo
        echo "1) Add Event"
        echo "2) View All Events"
        echo "3) Search Events"
        echo "4) Edit Event"
        echo "5) Remove Event"
        echo "6) Back to Main Menu"
        echo
        read -rp "Choose an option: " opt

        case "$opt" in
            1) add_event ;;
            2) view_all_events ;;
            3) search_events ;;
            4) edit_event ;;
            5) remove_event ;;
            6) return ;;
            *) echo "Invalid option." ; sleep 1 ;;
        esac
    done
}

# ==========================
# Event Functions
# ==========================
add_event() {
    clear
    echo "=== Add Event ==="
    show_nav_hint

    while true; do
        read -rp "Event Name: " event
        if [[ "${event,,}" == "m" ]]; then return; fi

        if is_blank "$event"; then
            echo "Event name cannot be blank."
        else
            break
        fi
    done

    while true; do
        read -rp "Event Date (DD-MM-YYYY): " date
        if [[ "${date,,}" == "m" ]]; then return; fi

        if ! valid_date "$date"; then
            echo "Date must be in format DD-MM-YYYY."
        else
            break
        fi
    done

    while true; do
        read -rp "Venue: " venue
        if [[ "${venue,,}" == "m" ]]; then return; fi

        if is_blank "$venue"; then
            echo "Venue cannot be blank."
        else
            break
        fi
    done

    if awk -F, -v event="$event" -v date="$date" -v venue="$venue" '
        NR>1 && tolower($2)==tolower(event) && $3==date && tolower($4)==tolower(venue) {found=1}
        END {exit !found}
    ' "$EVENTS_FILE"; then
        echo
        echo "Duplicate found: this exact event already exists."
        pause
        return
    fi

    if awk -F, -v date="$date" -v venue="$venue" '
        NR>1 && $3==date && tolower($4)==tolower(venue) {found=1}
        END {exit !found}
    ' "$EVENTS_FILE"; then
        echo
        echo "Error: There is already an event at this venue on this date."
        pause
        return
    fi

    new_id=$(generate_event_id)

    echo
    echo "Please confirm:"
    echo "Event ID: $new_id"
    echo "Event Name: $event"
    echo "Date: $date"
    echo "Venue: $venue"
    echo
    read -rp "Save this event? (Y/N): " confirm

    case "${confirm,,}" in
        y|yes)
            echo "$new_id,$event,$date,$venue" >> "$EVENTS_FILE"
            echo "Event saved."
            ;;
        *)
            echo "Cancelled. Nothing saved."
            ;;
    esac

    pause
}

view_all_events() {
    clear
    echo "=== All Events ==="
    echo

    if [[ $(wc -l < "$EVENTS_FILE") -le 1 ]]; then
        echo "No events found."
        pause
        return
    fi

    if command -v column >/dev/null 2>&1; then
        column -t -s, "$EVENTS_FILE"
    else
        cat "$EVENTS_FILE"
    fi

    pause
}

search_events() {
    while true; do
        clear
        echo "=== Search Events ==="
        echo
        echo "1) Search by Event Name"
        echo "2) Search by Date"
        echo "3) Search by Venue"
        echo "4) Back"
        echo

        read -rp "Choose an option: " opt

        case "$opt" in
            1)
                read -rp "Enter event name to search (press Enter to go back): " keyword
                if is_blank "$keyword"; then
                    continue
                fi

                matches=$(awk -F, -v keyword="$keyword" '
                    BEGIN {IGNORECASE=1}
                    NR>1 && $2 ~ keyword
                ' "$EVENTS_FILE")

                echo
                if [[ -n "$matches" ]]; then
                    {
                        echo "EID,Event,Date,Venue"
                        echo "$matches"
                    } | column -t -s,
                else
                    echo "No events found."
                fi
                pause
                ;;

            2)
                read -rp "Enter date (DD-MM-YYYY) (press Enter to go back): " date
                if is_blank "$date"; then
                    continue
                fi

                if ! valid_date "$date"; then
                    echo "Date must be in format DD-MM-YYYY."
                    pause
                    continue
                fi

                matches=$(awk -F, -v date="$date" 'NR>1 && $3==date' "$EVENTS_FILE")

                echo
                if [[ -n "$matches" ]]; then
                    {
                        echo "EID,Event,Date,Venue"
                        echo "$matches"
                    } | column -t -s,
                else
                    echo "No events found on that date."
                fi
                pause
                ;;

            3)
                read -rp "Enter venue to search (press Enter to go back): " keyword
                if is_blank "$keyword"; then
                    continue
                fi

                matches=$(awk -F, -v keyword="$keyword" '
                    BEGIN {IGNORECASE=1}
                    NR>1 && $4 ~ keyword
                ' "$EVENTS_FILE")

                echo
                if [[ -n "$matches" ]]; then
                    {
                        echo "EID,Event,Date,Venue"
                        echo "$matches"
                    } | column -t -s,
                else
                    echo "No events found at that venue."
                fi
                pause
                ;;

            4)
                return
                ;;

            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

edit_event() {
    while true; do
        clear
        echo "=== Edit Event ==="
        echo "Press Enter to keep current value."
        echo "Enter M at any prompt to go back."
        echo

        if [[ $(wc -l < "$EVENTS_FILE") -le 1 ]]; then
            echo "No events found."
            pause
            return
        fi

        echo "Available Events:"
        if command -v column >/dev/null 2>&1; then
            column -t -s, "$EVENTS_FILE"
        else
            cat "$EVENTS_FILE"
        fi
        echo

        read -rp "Enter Event ID to edit: " event_id
        if [[ "${event_id,,}" == "m" ]]; then return; fi

        if is_blank "$event_id"; then
            echo "Event ID cannot be blank."
            pause
            continue
        fi

        match=$(awk -F, -v id="$event_id" 'NR>1 && $1==id' "$EVENTS_FILE")

        if [[ -z "$match" ]]; then
            echo "No event found with that ID."
            pause
            continue
        fi

        current_name=$(echo "$match" | awk -F, '{print $2}')
        current_date=$(echo "$match" | awk -F, '{print $3}')
        current_venue=$(echo "$match" | awk -F, '{print $4}')

        echo
        echo "Current Event Details:"
        echo "Name:  $current_name"
        echo "Date:  $current_date"
        echo "Venue: $current_venue"
        echo

        read -rp "New Event Name [$current_name] (Enter = keep, M = back): " new_name
        if [[ "${new_name,,}" == "m" ]]; then return; fi

        read -rp "New Date [$current_date] (Enter = keep, M = back): " new_date
        if [[ "${new_date,,}" == "m" ]]; then return; fi

        read -rp "New Venue [$current_venue] (Enter = keep, M = back): " new_venue
        if [[ "${new_venue,,}" == "m" ]]; then return; fi

        [[ -z "$new_name" ]] && new_name="$current_name"
        [[ -z "$new_date" ]] && new_date="$current_date"
        [[ -z "$new_venue" ]] && new_venue="$current_venue"

        if is_blank "$new_name"; then
            echo "Event name cannot be blank."
            pause
            continue
        fi

        if is_blank "$new_venue"; then
            echo "Venue cannot be blank."
            pause
            continue
        fi

        if ! valid_date "$new_date"; then
            echo "Date must be in format DD-MM-YYYY."
            pause
            continue
        fi

        if awk -F, -v id="$event_id" -v event="$new_name" -v date="$new_date" -v venue="$new_venue" '
            NR>1 && $1!=id && tolower($2)==tolower(event) && $3==date && tolower($4)==tolower(venue) {found=1}
            END {exit !found}
        ' "$EVENTS_FILE"; then
            echo "Duplicate found: another event already has these exact details."
            pause
            continue
        fi

        if awk -F, -v id="$event_id" -v date="$new_date" -v venue="$new_venue" '
            NR>1 && $1!=id && $3==date && tolower($4)==tolower(venue) {found=1}
            END {exit !found}
        ' "$EVENTS_FILE"; then
            echo "Error: There is already another event at this venue on this date."
            pause
            continue
        fi

        echo
        echo "Updated Event Details:"
        echo "Event ID: $event_id"
        echo "Name:     $new_name"
        echo "Date:     $new_date"
        echo "Venue:    $new_venue"
        echo

        read -rp "Save these changes? (Y/N or M to cancel): " confirm
        if [[ "${confirm,,}" == "m" ]]; then return; fi

        case "${confirm,,}" in
            y|yes)
                awk -F, -v id="$event_id" -v name="$new_name" -v date="$new_date" -v venue="$new_venue" '
                    BEGIN {OFS=","}
                    NR==1 {print; next}
                    $1==id {$2=name; $3=date; $4=venue}
                    {print}
                ' "$EVENTS_FILE" > temp.csv
                mv temp.csv "$EVENTS_FILE"
                echo "Event updated."
                pause
                return
                ;;
            *)
                echo "Edit cancelled."
                pause
                return
                ;;
        esac
    done
}

remove_event() {
    while true; do
        clear
        echo "=== Remove Event ==="
        echo "Enter M at any prompt to go back."
        echo

        if [[ $(wc -l < "$EVENTS_FILE") -le 1 ]]; then
            echo "No events found."
            pause
            return
        fi

        echo "Available Events:"
        if command -v column >/dev/null 2>&1; then
            column -t -s, "$EVENTS_FILE"
        else
            cat "$EVENTS_FILE"
        fi
        echo

        read -rp "Enter Event ID to delete: " event_id
        if [[ "${event_id,,}" == "m" ]]; then return; fi

        if is_blank "$event_id"; then
            echo "Event ID cannot be blank."
            pause
            continue
        fi

        match=$(awk -F, -v id="$event_id" 'NR>1 && $1==id' "$EVENTS_FILE")

        if [[ -z "$match" ]]; then
            echo "No event found with that ID."
            pause
            continue
        fi

        linked_fights=$(awk -F, -v eid="$event_id" 'NR>1 && $2==eid' "$FIGHTS_FILE")

        if [[ -n "$linked_fights" ]]; then
            echo "Cannot delete this event because fights are linked to it."
            echo
            echo "Linked fights:"
            display_fight_rows "$linked_fights"
            echo
            echo "Remove or reassign those fights first."
            pause
            continue
        fi

        current_name=$(echo "$match" | awk -F, '{print $2}')
        current_date=$(echo "$match" | awk -F, '{print $3}')
        current_venue=$(echo "$match" | awk -F, '{print $4}')

        echo
        echo "Event found:"
        echo "Event ID: $event_id"
        echo "Name:     $current_name"
        echo "Date:     $current_date"
        echo "Venue:    $current_venue"
        echo

        read -rp "Are you sure you want to delete this event? (Y/N or M to cancel): " confirm
        if [[ "${confirm,,}" == "m" ]]; then return; fi

        case "${confirm,,}" in
            y|yes)
                awk -F, -v id="$event_id" '
                    BEGIN {OFS=","}
                    NR==1 {print; next}
                    $1!=id {print}
                ' "$EVENTS_FILE" > temp.csv
                mv temp.csv "$EVENTS_FILE"
                echo "Event deleted."
                pause
                return
                ;;
            *)
                echo "Deletion cancelled."
                pause
                return
                ;;
        esac
    done
}

# ==========================
# Fights Menu
# ==========================
fights_menu() {
    while true; do
        clear
        echo "=== Fights Menu ==="
        echo
        echo "1) Add Fight"
        echo "2) View All Fights"
        echo "3) Search Fights"
        echo "4) Edit Fight"
        echo "5) Remove Fight"
        echo "6) View Fights Grouped by Event"
        echo "7) Back to Main Menu"
        echo
        read -rp "Choose an option: " opt

        case "$opt" in
            1) add_fight ;;
            2) view_all_fights ;;
            3) search_fights ;;
            4) edit_fight ;;
            5) remove_fight ;;
            6) view_fights_grouped_by_event ;;
            7) return ;;
            *) echo "Invalid option."; sleep 1 ;;
        esac
    done
}

# ==========================
# Fight Functions
# ==========================

add_fight() {
    clear
    echo "=== Add Fight ==="
    echo "Enter M at any prompt to go back."
    echo

    # MAKE SURE EVENTS EXIST
    if [[ $(wc -l < "$EVENTS_FILE") -le 1 ]]; then
        echo "No events found. Please add an event first."
        pause
        return
    fi

    # SHOW EVENTS
    echo "Available Events:"
    echo
    if command -v column >/dev/null 2>&1; then
        column -t -s, "$EVENTS_FILE"
    else
        cat "$EVENTS_FILE"
    fi
    echo

    # CHOOSE EVENT
    while true; do
        read -rp "Enter Event ID: " event_id
        if [[ "${event_id,,}" == "m" ]]; then return; fi

        event_id=$(printf '%s' "$event_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        if is_blank "$event_id"; then
            echo "Event ID cannot be blank."
        elif ! event_exists "$event_id"; then
            echo "That Event ID does not exist."
        else
            event_name=$(get_event_name_by_id "$event_id")
            event_date=$(get_event_date_by_id "$event_id")
            event_venue=$(get_event_venue_by_id "$event_id")
            echo "Selected Event: $event_name on $event_date at $event_venue"
            break
        fi
    done

    echo
    echo "Available Boxers:"
    display_boxer_rows
    echo

    # FINAL FIGHTER VARIABLES
    final_red_id=""
    final_red_name=""
    final_red_wc=""
    final_blue_id=""
    final_blue_name=""
    final_blue_wc=""

    # RED CORNER
    while true; do
        read -rp "Red Corner Boxer ID: " input_red_id
        if [[ "${input_red_id,,}" == "m" ]]; then return; fi

        input_red_id=$(printf '%s' "$input_red_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        if is_blank "$input_red_id"; then
            echo "Red corner ID cannot be blank."
            continue
        fi

        temp_red_name=$(get_boxer_name_by_id "$input_red_id")
        temp_red_wc=$(get_boxer_weightclass_by_id "$input_red_id")

        if is_blank "$temp_red_name"; then
            echo "That ID does not belong to a registered Boxer."
        elif fighter_booked_on_date "$input_red_id" "$event_date" ""; then
            echo "Scheduling error: $temp_red_name is already booked to fight on $event_date."
        else
            final_red_id="$input_red_id"
            final_red_name="$temp_red_name"
            final_red_wc="$temp_red_wc"
            echo "Selected Red Corner: $final_red_name ($final_red_wc)"
            break
        fi
    done

    # BLUE CORNER
    while true; do
        read -rp "Blue Corner Boxer ID: " input_blue_id
        if [[ "${input_blue_id,,}" == "m" ]]; then return; fi

        input_blue_id=$(printf '%s' "$input_blue_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

        if is_blank "$input_blue_id"; then
            echo "Blue corner ID cannot be blank."
            continue
        fi

        temp_blue_name=$(get_boxer_name_by_id "$input_blue_id")
        temp_blue_wc=$(get_boxer_weightclass_by_id "$input_blue_id")

        if is_blank "$temp_blue_name"; then
            echo "That ID does not belong to a registered Boxer."
        elif fighter_booked_on_date "$input_blue_id" "$event_date" ""; then
            echo "Scheduling error: $temp_blue_name is already booked to fight on $event_date."
        elif [[ "$final_red_id" == "$input_blue_id" ]]; then
            echo "Red and Blue corner fighters cannot be the same person."
        elif [[ "$final_red_wc" != "$temp_blue_wc" ]]; then
            echo "Matchmaking error: both fighters must be in the same weightclass."
            echo "Red Corner: $final_red_name ($final_red_wc)"
            echo "Blue Corner: $temp_blue_name ($temp_blue_wc)"
        else
            final_blue_id="$input_blue_id"
            final_blue_name="$temp_blue_name"
            final_blue_wc="$temp_blue_wc"
            echo "Selected Blue Corner: $final_blue_name ($final_blue_wc)"
            break
        fi
    done

    # SAFETY CHECK BEFORE CONTINUING
    if is_blank "$final_red_id" || is_blank "$final_blue_id"; then
        echo "Error: fighter IDs were not stored correctly."
        pause
        return
    fi

    wc="$final_red_wc"

    # STATUS
    while true; do
        echo
        echo "Status:"
        echo "1) Scheduled"
        echo "2) Completed"
        echo "3) Cancelled"
        echo "M) Back"
        read -rp "Choose: " s

        if [[ "${s,,}" == "m" ]]; then return; fi

        case "$s" in
            1) status="Scheduled"; break ;;
            2) status="Completed"; break ;;
            3) status="Cancelled"; break ;;
            *) echo "Invalid choice. Pick 1-3." ;;
        esac
    done

    # GENERATE NEW FIGHT ID
    last_id=$(tail -n 1 "$FIGHTS_FILE" | awk -F, '{print $1}')
    if [[ "$last_id" == "FID" || -z "$last_id" ]]; then
        new_id="F001"
    else
        last_num=${last_id#F}
        new_num=$((10#$last_num + 1))
        printf -v new_id "F%03d" "$new_num"
    fi

    echo
    echo "Please confirm:"
    echo "Fight ID: $new_id"
    echo "Event ID: $event_id"
    echo "Event: $event_name"
    echo "Date: $event_date"
    echo "Venue: $event_venue"
    echo "Red Corner: $final_red_name ($final_red_id)"
    echo "Blue Corner: $final_blue_name ($final_blue_id)"
    echo "Weightclass: $wc"
    echo "Status: $status"
    echo
    read -rp "Save this fight? (Y/N or M to cancel): " confirm

    if [[ "${confirm,,}" == "m" ]]; then return; fi

    case "${confirm,,}" in
        y|yes)
            echo "$new_id,$event_id,$final_red_id,$final_blue_id,$wc,$status" >> "$FIGHTS_FILE"
            echo "Fight saved."
            ;;
        *)
            echo "Cancelled. Nothing saved."
            ;;
    esac

    pause
}

view_all_fights() {
    clear
    echo "=== All Fights ==="
    echo

    if [[ $(wc -l < "$FIGHTS_FILE") -le 1 ]]; then
        echo "No fights found."
        pause
        return
    fi

    display_fight_rows
    pause
}

search_fights() {
    while true; do
        clear
        echo "=== Search Fights ==="
        echo
        echo "1) Search by Event"
        echo "2) Search by Fighter Name"
        echo "3) Search by Status"
        echo "4) Back"
        echo

        read -rp "Choose: " opt

        case "$opt" in
            1)
                read -rp "Enter event name (press Enter to go back): " keyword
                if is_blank "$keyword"; then
                    continue
                fi

                matches=$(awk -F, 'NR>1 {print}' "$FIGHTS_FILE" | while IFS=, read -r fid eid red_id blue_id wc status; do
                    event_name=$(get_event_name_by_id "$eid")
                    if [[ "${event_name,,}" == *"${keyword,,}"* ]]; then
                        echo "$fid,$eid,$red_id,$blue_id,$wc,$status"
                    fi
                done)

                echo
                if [[ -n "$matches" ]]; then
                    echo "Fights for event: $keyword"
                    display_fight_rows "$matches"
                else
                    echo "No fights found for that event."
                fi

                pause
                ;;

            2)
                read -rp "Enter fighter name (press Enter to go back): " keyword
                if is_blank "$keyword"; then
                    continue
                fi

                matches=$(awk -F, 'NR>1 {print}' "$FIGHTS_FILE" | while IFS=, read -r fid eid red_id blue_id wc status; do
                    red_name=$(get_boxer_name_by_id "$red_id")
                    blue_name=$(get_boxer_name_by_id "$blue_id")

                    if [[ "${red_name,,}" == *"${keyword,,}"* || "${blue_name,,}" == *"${keyword,,}"* ]]; then
                        echo "$fid,$eid,$red_id,$blue_id,$wc,$status"
                    fi
                done)

                echo
                if [[ -n "$matches" ]]; then
                    display_fight_rows "$matches"
                else
                    echo "No fights found."
                fi

                pause
                ;;

            3)
                echo
                echo "1) Scheduled"
                echo "2) Completed"
                echo "3) Cancelled"
                echo "M) Back"
                echo

                read -rp "Choose status: " s

                if [[ "${s,,}" == "m" ]]; then
                    continue
                fi

                case "$s" in
                    1) status="Scheduled" ;;
                    2) status="Completed" ;;
                    3) status="Cancelled" ;;
                    *)
                        echo "Invalid option."
                        pause
                        continue
                        ;;
                esac

                matches=$(awk -F, -v status="$status" 'NR>1 && tolower($6)==tolower(status)' "$FIGHTS_FILE")

                echo
                if [[ -n "$matches" ]]; then
                    display_fight_rows "$matches"
                else
                    echo "No fights found."
                fi

                pause
                ;;

            4)
                return
                ;;

            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

remove_fight() {
    while true; do
        clear
        echo "=== Remove Fight ==="
        echo
        echo "1) Remove one fight by ID"
        echo "2) Remove multiple fights by Status"
        echo "3) Back"
        echo

        read -rp "Choose: " opt

        case "$opt" in
            1)
                if [[ $(wc -l < "$FIGHTS_FILE") -le 1 ]]; then
                    echo "No fights found."
                    pause
                    continue
                fi

                echo
                echo "Available Fights:"
                display_fight_rows
                echo

                read -rp "Enter Fight ID to delete (or M to go back): " id
                if [[ "${id,,}" == "m" ]]; then
                    continue
                fi

                if is_blank "$id"; then
                    echo "Fight ID cannot be blank."
                    pause
                    continue
                fi

                match=$(awk -F, -v id="$id" 'NR>1 && $1==id' "$FIGHTS_FILE")

                if [[ -z "$match" ]]; then
                    echo "No fight found with that ID."
                    pause
                    continue
                fi

                echo
                echo "Fight found:"
                display_fight_rows "$match"
                echo

                read -rp "Are you sure you want to delete this fight? (Y/N or M to cancel): " confirm
                if [[ "${confirm,,}" == "m" ]]; then
                    continue
                fi

                case "${confirm,,}" in
                    y|yes)
                        awk -F, -v id="$id" '
                            BEGIN {OFS=","}
                            NR==1 {print; next}
                            $1 != id {print}
                        ' "$FIGHTS_FILE" > temp.csv
                        mv temp.csv "$FIGHTS_FILE"
                        echo "Fight deleted."
                        ;;
                    *)
                        echo "Deletion cancelled."
                        ;;
                esac

                pause
                ;;

            2)
                echo
                echo "1) Scheduled"
                echo "2) Completed"
                echo "3) Cancelled"
                echo "M) Back"
                echo

                read -rp "Choose status to delete: " s

                if [[ "${s,,}" == "m" ]]; then
                    continue
                fi

                case "$s" in
                    1) status="Scheduled" ;;
                    2) status="Completed" ;;
                    3) status="Cancelled" ;;
                    *)
                        echo "Invalid option."
                        pause
                        continue
                        ;;
                esac

                matches=$(awk -F, -v status="$status" 'NR>1 && tolower($6)==tolower(status)' "$FIGHTS_FILE")

                if [[ -z "$matches" ]]; then
                    echo "No fights found with status: $status"
                    pause
                    continue
                fi

                echo
                echo "The following fights will be deleted:"
                display_fight_rows "$matches"
                echo

                read -rp "Are you sure you want to delete ALL $status fights? (Y/N or M to cancel): " confirm
                if [[ "${confirm,,}" == "m" ]]; then
                    continue
                fi

                case "${confirm,,}" in
                    y|yes)
                        awk -F, -v status="$status" '
                            BEGIN {OFS=","}
                            NR==1 {print; next}
                            tolower($6) != tolower(status) {print}
                        ' "$FIGHTS_FILE" > temp.csv
                        mv temp.csv "$FIGHTS_FILE"
                        echo "All $status fights deleted."
                        ;;
                    *)
                        echo "Deletion cancelled."
                        ;;
                esac

                pause
                ;;

            3)
                return
                ;;

            *)
                echo "Invalid option."
                sleep 1
                ;;
        esac
    done
}

edit_fight() {
    while true; do
        clear
        echo "=== Edit Fight ==="
        echo "Press Enter to keep current value."
        echo "Enter M at any prompt to go back."
        echo

        if [[ $(wc -l < "$FIGHTS_FILE") -le 1 ]]; then
            echo "No fights found."
            pause
            return
        fi

        echo "Available Fights:"
        display_fight_rows
        echo

        read -rp "Enter Fight ID to edit (or M to go back): " fight_id
        if [[ "${fight_id,,}" == "m" ]]; then return; fi

        if is_blank "$fight_id"; then
            echo "Fight ID cannot be blank."
            pause
            continue
        fi

        match=$(awk -F, -v id="$fight_id" 'NR>1 && $1==id' "$FIGHTS_FILE")

        if [[ -z "$match" ]]; then
            echo "No fight found with that ID."
            pause
            continue
        fi

        current_eid=$(echo "$match" | awk -F, '{print $2}')
        current_red_id=$(echo "$match" | awk -F, '{print $3}')
        current_blue_id=$(echo "$match" | awk -F, '{print $4}')
        current_wc=$(echo "$match" | awk -F, '{print $5}')
        current_status=$(echo "$match" | awk -F, '{print $6}')

        current_event=$(get_event_name_by_id "$current_eid")
        current_red=$(get_boxer_name_by_id "$current_red_id")
        current_blue=$(get_boxer_name_by_id "$current_blue_id")

        echo
        echo "Current Fight Details:"
        echo "Event:       $current_event ($current_eid)"
        echo "Red Corner:  $current_red ($current_red_id)"
        echo "Blue Corner: $current_blue ($current_blue_id)"
        echo "Weightclass: $current_wc"
        echo "Status:      $current_status"
        echo

        echo "Available Events:"
        column -t -s, "$EVENTS_FILE"
        echo

        read -rp "New Event ID [$current_eid] (Enter = keep, M = back): " new_eid
        if [[ "${new_eid,,}" == "m" ]]; then return; fi
        [[ -z "$new_eid" ]] && new_eid="$current_eid"

        if ! event_exists "$new_eid"; then
            echo "That Event ID does not exist."
            pause
            continue
        fi

        new_event_date=$(get_event_date_by_id "$new_eid")

        echo
        echo "Available Boxers:"
        display_boxer_rows
        echo

        read -rp "New Red Corner Boxer ID [$current_red_id] (Enter = keep, M = back): " new_red_id
        if [[ "${new_red_id,,}" == "m" ]]; then return; fi
        [[ -z "$new_red_id" ]] && new_red_id="$current_red_id"

        new_red=$(get_boxer_name_by_id "$new_red_id")
        new_red_wc=$(get_boxer_weightclass_by_id "$new_red_id")

        if is_blank "$new_red"; then
            echo "Invalid Red Corner boxer."
            pause
            continue
        fi

        if fighter_booked_on_date "$new_red_id" "$new_event_date" "$fight_id"; then
            echo "Scheduling error: $new_red is already booked on $new_event_date."
            pause
            continue
        fi

        read -rp "New Blue Corner Boxer ID [$current_blue_id] (Enter = keep, M = back): " new_blue_id
        if [[ "${new_blue_id,,}" == "m" ]]; then return; fi
        [[ -z "$new_blue_id" ]] && new_blue_id="$current_blue_id"

        new_blue=$(get_boxer_name_by_id "$new_blue_id")
        new_blue_wc=$(get_boxer_weightclass_by_id "$new_blue_id")

        if is_blank "$new_blue"; then
            echo "Invalid Blue Corner boxer."
            pause
            continue
        fi

        if fighter_booked_on_date "$new_blue_id" "$new_event_date" "$fight_id"; then
            echo "Scheduling error: $new_blue is already booked on $new_event_date."
            pause
            continue
        fi

        if [[ "$new_red_id" == "$new_blue_id" ]]; then
            echo "Fighters cannot be the same."
            pause
            continue
        fi

        if [[ "$new_red_wc" != "$new_blue_wc" ]]; then
            echo "Fighters must be same weightclass."
            pause
            continue
        fi

        new_wc="$new_red_wc"

        echo
        echo "1) Scheduled"
        echo "2) Completed"
        echo "3) Cancelled"
        echo "4) Keep Current [$current_status]"
        echo "M) Back"
        read -rp "Choose status (Enter = keep current, M = back): " s

        if [[ "${s,,}" == "m" ]]; then return; fi

        case "$s" in
            1) new_status="Scheduled" ;;
            2) new_status="Completed" ;;
            3) new_status="Cancelled" ;;
            4|"") new_status="$current_status" ;;
            *) echo "Invalid option."; pause; continue ;;
        esac

        echo
        echo "Save changes? (Y/N or M to cancel)"
        read -rp "> " confirm

        if [[ "${confirm,,}" == "m" ]]; then return; fi

        case "${confirm,,}" in
            y|yes)
                awk -F, -v id="$fight_id" -v eid="$new_eid" -v red="$new_red_id" -v blue="$new_blue_id" -v wc="$new_wc" -v status="$new_status" '
                    BEGIN {OFS=","}
                    NR==1 {print; next}
                    $1==id {$2=eid; $3=red; $4=blue; $5=wc; $6=status}
                    {print}
                ' "$FIGHTS_FILE" > temp.csv
                mv temp.csv "$FIGHTS_FILE"
                echo "Fight updated."
                pause
                return
                ;;
            *)
                echo "Cancelled."
                pause
                return
                ;;
        esac
    done
}

view_fights_grouped_by_event() {
    clear
    echo "=== Fights Grouped by Event ==="
    echo

    if [[ $(wc -l < "$EVENTS_FILE") -le 1 ]]; then
        echo "No events found."
        pause
        return
    fi

    if [[ $(wc -l < "$FIGHTS_FILE") -le 1 ]]; then
        echo "No fights found."
        pause
        return
    fi

    found_any=0

    while IFS=, read -r eid event_name event_date event_venue; do
        [[ "$eid" == "EID" ]] && continue

        event_fights=$(awk -F, -v eid="$eid" 'NR>1 && $2==eid' "$FIGHTS_FILE")

        if [[ -n "$event_fights" ]]; then
            found_any=1

            echo "========================================"
            echo "Event ID: $eid"
            echo "Event:    $event_name"
            echo "Date:     $event_date"
            echo "Venue:    $event_venue"
            echo "========================================"

            {
                echo "FightID,Red Corner,Blue Corner,Weightclass,Status"

                echo "$event_fights" | while IFS=, read -r fid eid red_id blue_id wc status; do
                    red_id=$(printf '%s' "$red_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                    blue_id=$(printf '%s' "$blue_id" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

                    red_name=$(get_boxer_name_by_id "$red_id")
                    blue_name=$(get_boxer_name_by_id "$blue_id")

                    echo "$fid,$red_name,$blue_name,$wc,$status"
                done
            } | column -t -s,

            echo
        fi
    done < "$EVENTS_FILE"

    if [[ $found_any -eq 0 ]]; then
        echo "No fight cards found."
    fi

    pause
}

# ==========================
# Reports Menu
# ==========================
reports_menu() {
    while true; do
        clear
        echo "=== Reports Menu ==="
        echo
        echo "1) System Summary"
        echo "2) Members by Role"
        echo "3) Upcoming Fights"
        echo "4) Fights Grouped by Event"
        echo "5) Back"
        echo

        read -rp "Choose an option: " opt

        case "$opt" in
            1) system_summary ;;
            2) members_by_role ;;
            3) upcoming_fights ;;
            4) view_fights_grouped_by_event ;;
            5) return ;;
            *) echo "Invalid option." ; sleep 1 ;;
        esac
    done
}

# ==========================
# Report Functions
# ==========================
system_summary() {
    clear
    echo "=== System Summary ==="
    echo

    total_members=$(( $(wc -l < "$MEMBERS_FILE") - 1 ))
    total_boxers=$(awk -F, 'NR>1 && tolower($6)=="boxer"' "$MEMBERS_FILE" | wc -l)
    total_events=$(( $(wc -l < "$EVENTS_FILE") - 1 ))
    total_fights=$(( $(wc -l < "$FIGHTS_FILE") - 1 ))

    echo "Total Members: $total_members"
    echo "Total Boxers:  $total_boxers"
    echo "Total Events:  $total_events"
    echo "Total Fights:  $total_fights"

    pause
}

members_by_role() {
    clear
    echo "=== Members by Role ==="
    echo

    echo "--- Boxers ---"
    awk -F, 'NR==1 || tolower($6)=="boxer"' "$MEMBERS_FILE" | column -t -s,
    echo

    echo "--- Coaches ---"
    awk -F, 'NR==1 || tolower($6)=="coach"' "$MEMBERS_FILE" | column -t -s,
    echo

    echo "--- Staff ---"
    awk -F, 'NR==1 || tolower($6)=="staff"' "$MEMBERS_FILE" | column -t -s,
    echo

    pause
}

upcoming_fights() {
    clear
    echo "=== Upcoming Fights (Scheduled) ==="
    echo

    matches=$(awk -F, 'NR > 1 && tolower($6) == "scheduled"' "$FIGHTS_FILE")

    if [[ -n "$matches" ]]; then
        display_fight_rows "$matches"
    else
        echo "No upcoming fights."
    fi

    pause
}

# ==========================
# Main Menu
# ==========================
main_menu() {
    while true; do
        clear
        echo "==================================="
        echo "     Boxing Club Management"
        echo "==================================="
        echo "1) Members Menu"
        echo "2) Event Menu"
        echo "3) Fight Menu"
        echo "4) Reports"
        echo "5) Exit"
        echo "-----------------------------------"
        echo

        read -rp "Choose an option: " choice

        case "$choice" in
            1) members_menu ;;
            2) events_menu ;;
            3) fights_menu ;;
            4) reports_menu ;;
            5) exit_program ;;
            *) echo "Invalid option." ; sleep 1 ;;
        esac
    done
}

# ==========================
# Start Program
# ==========================
init_files
main_menu