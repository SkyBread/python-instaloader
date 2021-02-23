##  ========================================
##
#   Instagram Downloader (BETA)
#   Last Edit: 10/Dec/2020
##
##  ========================================

#! /bin/bash
clear

##  ========================================
##
#   Initialization
##
##  ========================================
dl_mode=""
dl_login_id="Anonymous"
dl_login_text=""
dl_opt_text="--no-captions --no-metadata-json --no-compress-json"
#   Download options (profile)
dl_opt_NoPosts="n"
dl_opt_NoProfilePic="n"
dl_opt_Stories="n"
dl_opt_Highlights="n"
dl_opt_Tagged="n"
dl_opt_igtv="n"
dl_opt_FastUpdate="n"
#   Download options (profile / posts / hashtags)
#dl_opt_Count=1000
dl_opt_NoPictures="n"
dl_opt_NoVideos="n"
dl_opt_NoVideoThumbs="n"
dl_opt_Comment="n"
dl_opt_NoCaptions="y"
dl_opt_NoMetadataJSON="y"
dl_opt_NoCompressJSON="y"

##  ========================================
##
#   Sub functions
##
##  ========================================

#   Login to Instagarm
function instadl_login(){
    clear
    ##
    #   Username
    ##
    echo "========================================"
    echo "Instagram Downloader (BETA)"
    echo ""
    echo "Login to Instagram"
    echo ""
    echo "Instaloader can login to Instagram. This allows downloading private profiles. Your session cookie (not your password!) will be saved to a local file to be reused next time you want Instaloader to login."
    echo "========================================"
    echo "Please enter your Instagram username:"
    read u
    if [ "$u" != "" ]
    then
        dl_login_text="--login $u"
        dl_login_id=$u
        echo "You may required to enter your password below and a photo will be downloaded for connection testing."
        instaloader $dl_login_text --no-captions --no-metadata-json --no-compress-json --dirname-pattern=dummy -- -CHf2LwOlFV_
    else
        dl_login_text=""
        dl_login_id="Anonymous"
        echo "Running in anonymous mode, some features might be limited."
    fi
    echo "Press ENTER to back to main menu"
    read a
    return 0
}

#   Download Instagram Post
function instadl_post(){
    clear
    while [ 1 ]
    do
        echo "========================================"
        echo "Instagram Downloader (BETA)"
        echo ""
        case $dl_mode in
            POST)    echo "Download Instagram posts / videos";;
            HASHTAG) echo "Download Instagram posts / videos with #Hashtag";;
            PROFILE) echo "Download Instagram profile";;
            *)       echo "UNEXPECTED ERROR!!"; echo "Debug( \$dl_mode : $dl_mode )";;
        esac
        echo ""
        echo "========================================"
        echo "Download Options"
        echo "(Type 'SET' to edit settings or 'LOGIN' to change login user)"
        echo "Login as              : [$dl_login_id]"
        if [[ $dl_mode == "PROFILE" ]]
        then
            echo "No Posts              : [$dl_opt_NoPosts]"
            echo "No Profile Picture    : [$dl_opt_NoProfilePic]"
            echo "Download Stories      : [$dl_opt_Stories] (Login Requires)"
            echo "Download Highlights   : [$dl_opt_Highlights] (Login Requires)"
            echo "Download Tagged       : [$dl_opt_Tagged]"
            echo "Download igtv         : [$dl_opt_igtv]"
            echo "Fast Update           : [$dl_opt_FastUpdate]"

        fi
        if [[ $dl_mode == "HASHTAG" ]]
        then
            echo "Counts                : [$dl_opt_Count]"
        fi
        #echo "No picture            : [$dl_opt_NoPictures]"
        echo "No Videos             : [$dl_opt_NoVideos]"
        echo "No Video Thumbnails   : [$dl_opt_NoVideoThumbs]"
        echo "Download Comments     : [$dl_opt_Comment]"
        echo "No Captions           : [$dl_opt_NoCaptions]"
        echo "No Metadata json      : [$dl_opt_NoMetadataJSON]"
        echo "No Compress json      : [$dl_opt_NoCompressJSON]"
        echo "========================================"
        echo ""
        if [[ $dl_mode == "POST" ]]
        then
            echo "Please enter url of the instagram post to download"
            echo "(eg: https://www.instagram.com/p/CD8RODpBQOz/ )"
        elif [[ $dl_mode == "PROFILE" ]]
        then
            echo "Please enter instagram username to download"
            echo "(eg: mr.skybread )"
        elif [[ $dl_mode == "HASHTAG" ]]
        then
            echo "Please enter #hashtag of the instagram post to download"
            echo "(eg: #frenchie )"
        fi
        echo "or Type 'EXIT' to back to main menu:"
        read i
        
        #   Determine COMMAND
        case $i in
            EXIT)     echo "Press Enter(↵) to back to main menu"; read a; return 0;;
            SET)      echo "Press Enter(↵) to Continue"; read a; instadl_post_opt; continue;;
            LOGIN)    echo "Press Enter(↵) to Continue"; read a; instadl_login; clear; continue;;
            PROFILE)  dl_mode="PROFILE"; echo "Press Enter(↵) to Continue"; read a; clear; continue;;
            POST)     dl_mode="POST"; echo "Press Enter(↵) to Continue"; read a; clear; continue;;
            #HASHTAG)  dl_mode="HASHTAG"; echo "Press Enter(↵) to Continue"; read a; continue;;
            *)        link=$i;;

        esac

        if [[ $dl_mode == "POST" ]]
        then
            #   Determine the vaild links
            if [[ $link =~ ^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/|www\.)?instagram.com+(\/.*)?$ ]]
            then
                # Determine post / igtv post
                str=${link%instagram\.com*}
                case $str in
                    https\:\/\/www\.)   post=${link/https:\/\/www\.instagram\.com\/};;
                    http\:\/\/www\.)    post=${link/http:\/\/www\.instagram\.com\/};;
                    https\:\/\/)        post=${link/https:\/\/instagram\.com\/};;
                    http\:\/\/)         post=${link/http:\/\/instagram\.com\/};;
                    www\.)              post=${link/www\.instagram\.com\/};;
                    *)                  post=${link/instagram\.com\/};;
                    
                esac

                if [[ $post =~ ^(p\/)+(.*)?$ ]]
                then
                    #   Post
                    post=${post:2:11}

                elif [[ $post =~ ^(tv\/)+(.*)?$ ]]
                then
                    #   IGTV post
                    post=${post:3:11}

                else 
                    #   Invaild url
                    echo "Invaild url!! Use Profile Download instead?"
                    echo "Press Enter(↵) to Continue"
                    read a
                    clear
                    continue
                fi
                
                instaloader $dl_login_text $dl_opt_text --dirname-pattern={profile} -- -$post
                echo "Press Enter(↵) to Continue"
                read a
                clear
                continue

            else
                #   Invaild url
                echo "Invaild url!!"
                echo "Press Enter(↵) to Continue"
                read a
                clear
                continue

            fi
        elif [[ $dl_mode == "PROFILE" ]]
        then
            instaloader $dl_login_text $dl_opt_text --dirname-pattern={profile} $i
            echo "Press Enter(↵) to Continue"
            read a
            clear
            continue
        else
            #   ERROR
            echo "========================================"
            echo "UNEXPECTED ERROR!!"
            echo "Login as: $dl_login_id"
            echo "Debug( \$dl_mode : $dl_mode )"
            echo "Debug( \$link : $link )"
            echo "Debug( \$dl_opt_text : $dl_opt_text )"
            echo "Press Enter(↵) to Continue"
            read a
            clear
            continue
        fi
    done
    return 0
}

#   Post Download Options
function instadl_post_opt(){
    clear
    dl_opt_text=""

    echo "========================================"
    echo "Instagram Downloader (BETA)"
    echo ""
    case $dl_mode in
        POST)    echo "Edit Options to Download Instagram posts / videos";;
        HASHTAG) echo "Edit Options to Download Instagram posts / videos with #Hashtag";;
        PROFILE) echo "Edit Options to Download Instagram profile";;
        *)       echo "UNEXPECTED ERROR!!";;
    esac
    echo ""
    if [[ $dl_mode == "PROFILE" ]]
    then
        #   No Post?
        while [ 1 ]
        do
            echo "[$dl_opt_NoPosts] No Posts (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_NoPosts="y"; dl_opt_text+=" --no-posts"; break;;
                n) dl_opt_NoPosts="n"; break;;
                \?) echo "Do not download regular posts.";;
                *) dl_opt_NoPosts="n"; break;;
            esac
        done
        #   No Profile Picture?
        while [ 1 ]
        do
            echo "[$dl_opt_NoProfilePic] No Profile Pictrure (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_NoProfilePic="y"; dl_opt_text+=" --no-profile-pic"; break;;
                n) dl_opt_NoProfilePic="n"; break;;
                \?) echo "Do not download profile picture.";;
                *) dl_opt_NoProfilePic="n"; break;;
            esac
        done
        #   Download Stories?
        while [ $dl_login_id != "Anonymous" ]
        do
            echo "[$dl_opt_Stories] Download Stories (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_Stories="y"; dl_opt_text+=" --stories"; break;;
                n) dl_opt_Stories="n"; break;;
                \?) echo "Also download stories of each profile that is downloaded.";;
                *) dl_opt_Stories="n"; break;;
            esac
        done
        #   Download Highlights?
        while [ $dl_login_id != "Anonymous" ]
        do
            echo "[$dl_opt_Highlights] Download Highlights (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_Highlights="y"; dl_opt_text+=" --highlights"; break;;
                n) dl_opt_Highlights="n"; break;;
                \?) echo "Also download highlights of each profile that is downloaded.";;
                *) dl_opt_Highlights="n"; break;;
            esac
        done
        #   Download Tagged?
        while [ 1 ]
        do
            echo "[$dl_opt_Tagged] Download Tagged (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_Tagged="y"; dl_opt_text+=" --tagged"; break;;
                n) dl_opt_Tagged="n"; break;;
                \?) echo "Also download posts where each profile is tagged.";;
                *) dl_opt_Tagged="n"; break;;
            esac
        done
        #   Download igtv?
        while [ 1 ]
        do
            echo "[$dl_opt_igtv] Download igtv (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_igtv="y"; dl_opt_text+=" --igtv"; break;;
                n) dl_opt_igtv="n"; break;;
                \?) echo "Also download IGTV videos.";;
                *) dl_opt_igtv="n"; break;;
            esac
        done
        #   Fast Update
        while [ 1 ]
        do
            echo "[$dl_opt_FastUpdate] Fast Update (y/n ?: Help)"
            read a
            case $a in
                y) dl_opt_FastUpdate="y"; dl_opt_text+=" --fast-update"; break;;
                n) dl_opt_FastUpdate="n"; break;;
                \?) echo "For each target, stop when encountering the first already-downloaded picture. This flag is recommended when you use Instaloader to update your personal Instagram archive.";;
                *) dl_opt_FastUpdate="n"; break;;
            esac
        done
    fi
    #   No Pictures?
    while [ 1 != 1 ]
    do
        echo "[$dl_opt_NoPictures] No Pictures (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_NoPictures="y"; dl_opt_text+=" --no-pictures"; break;;
            n) dl_opt_NoPictures="n"; break;;
            \?) echo "Do not download post pictures. Cannot be used together with 'fast update'. Implies 'no video thumbnails', does not imply 'no videos'.";;
            *) dl_opt_NoPictures="n"; break;;
        esac
    done
    #   No Videos?
    while [ 1 ]
    do
        echo "[$dl_opt_NoVideos] No Videos (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_NoVideos="y"; dl_opt_text+=" --no-videos"; break;;
            n) dl_opt_NoVideos="n"; break;;
            \?) echo "Do not download videos.";;
            *) dl_opt_NoVideos="n"; break;;
        esac
    done
    #   No Videos Thumbnails?
    while [ 1 ]
    do
        echo "[$dl_opt_NoVideoThumbs] No Videos Thumbnails (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_NoVideoThumbs="y"; dl_opt_text+=" --no-video-thumbnails"; break;;
            n) dl_opt_NoVideoThumbs="n"; break;;
            \?) echo "Do not download thumbnails of videos.";;
            *) dl_opt_NoVideoThumbs="n"; break;;
        esac
    done
    #   Download Comments?
    while [ 1 ]
    do
        echo "[$dl_opt_Comment] Download Comments (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_Comment="y"; dl_opt_text+=" --comments"; break;;
            n) dl_opt_Comment="n"; break;;
            \?) echo "Also Download and update comments for each post. This requires an additional request to the Instagram server for each post, which is why it is disabled by default.";;
            *) dl_opt_Comment="n"; break;;
        esac
    done
    #   No Captions?
    while [ 1 ]
    do
        echo "[$dl_opt_NoCaptions] No Captions (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_NoCaptions="y"; dl_opt_text+=" --no-captions"; break;;
            n) dl_opt_NoCaptions="n"; break;;
            \?) echo "Do not create txt files.";;
            *) dl_opt_NoCaptions="y"; dl_opt_text+=" --no-captions"; break;;
        esac
    done
    #   No Metadata JSON?
    while [ 1 ]
    do
        echo "[$dl_opt_NoMetadataJSON] No Metadata JSON (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_NoMetadataJSON="y"; dl_opt_text+=" --no-metadata-json"; break;;
            n) dl_opt_NoMetadataJSON="n"; break;;
            \?) echo "Do not create a JSON file containing the metadata of each post.";;
            *) dl_opt_NoMetadataJSON="y"; dl_opt_text+=" --no-metadata-json"; break;;
        esac
    done
    #   No Compress JSON?
    while [ 1 ]
    do
        echo "[$dl_opt_NoCompressJSON] No Compress JSON (y/n ?: Help)"
        read a
        case $a in
            y) dl_opt_NoCompressJSON="y"; dl_opt_text+=" --no-compress-json"; break;;
            n) dl_opt_NoCompressJSON="n"; break;;
            \?) echo "Do not xz compress JSON files, rather create pretty formatted JSONs.";;
            *) dl_opt_NoCompressJSON="y"; dl_opt_text+=" --no-compress-json"; break;;
        esac
    done

    clear
}

##  ========================================
##
#   Main Menu
##
##  ========================================
menu(){
    clear
    echo "========================================"
    echo "Instagram Downloader (BETA)"
    echo ""
    echo "========================================"
    echo "Login as: $dl_login_id"
    echo "Choose one of the below to continue:"
    echo "[ L ] Login to Instagram"
    echo "[ P ] Download Instagram profile"
    echo "[ O ] Download Instagram post / video"
    #echo "[ H ] Download Instagram post / video with #Hashtag"
    echo "[ E ] Exit this program"
    echo ":"
    read a
    case $a in
        l) instadl_login;;
        L) instadl_login;;
        p) dl_mode="PROFILE"; instadl_post;;
        P) dl_mode="PROFILE"; instadl_post;;
        o) dl_mode="POST"; instadl_post;;
        O) dl_mode="POST"; instadl_post;;
        #h) dl_mode="HASHTAG"; instadl_post;;
        #H) dl_mode="HASHTAG"; instadl_post;;
        e) exit 0;;
        E) exit 0;;
        *) echo "Invalid Operation"; echo "Press ENTER to back to main menu"; read a; menu;;
    esac

}

# Call the menu function
while [ 1 ]
do
    menu
done

exit 0