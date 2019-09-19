///
/// evelin (evilevelin)'s tracking script, v1.0
///
/// You are free to use this script for personal items.
/// You are NOT allowed to sell items with this script in it.
///
/// Point "ApiLocationEndpoint" to you api endpoint for storage 
/// of your locations.
///  


string ApiLocationEndpoint = "...";
integer EnableTracking = TRUE;


/// 
/// Builds a CSV string containing my current location info
///
string GetMyPosition()
{
    vector pos = llGetPos();
    list details = llGetParcelDetails(pos, [PARCEL_DETAILS_NAME]);

    return llList2CSV([
        (string)llRound(pos.x),
        (string)llRound(pos.z),
        llEscapeURL(llList2String(details, 0)),
        llEscapeURL(llGetRegionName())
    ]);     
}


///
/// Pushes the CSV string to the server for further processing
/// 
PushToServer(string locationData)
{
   llHTTPRequest(
        ApiLocationEndpoint,
        [
            HTTP_METHOD, "POST"
        ], 
        locationData
    );
}


default 
{
    state_entry()
    {
        llOwnerSay("Hello " + llGetDisplayName(llGetOwner()) + ". I am tracking you right now...");
        EnableTracking = 1;
        llSetTimerEvent(120);
    }
    
    
    timer() 
    {
        PushToServer(GetMyPosition());
    }
    

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) != llGetOwner())
        {
             llSay(0, "You are not allowed to touch my tracking ring!");
             return;
        }
        
        if(!EnableTracking)
        {
            llOwnerSay("Hello " + llGetDisplayName(llGetOwner()) + ". I am tracking you right now, be a good girl...");
            EnableTracking = TRUE;
            llSetTimerEvent(120);
            
        } else {
            llOwnerSay("Hello " + llGetDisplayName(llGetOwner()) + ". Tracking has stopped");
            EnableTracking = FALSE;
            llSetTimerEvent(0);
        }
    }
}
