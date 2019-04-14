"SEARCH <ROOM "

"PLACES for M3
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

"Rapid Transit Line Definitions and Identifiers"

<CONSTANT HALL-LINE-C 0>
<CONSTANT BALLROOM-LINE-C 1>
<CONSTANT EAST-HALL-LINE-C 2>
<CONSTANT GARAGE-LINE-C 3>
<CONSTANT OUTSIDE-LINE-C 4>

<CONSTANT LINES 5>

<OBJECT ROOMS>

\

<ROOM CIRCLE
      (IN ROOMS)
      (SYNONYM DRIVEWAY CIRCLE)
      (ADJECTIVE CIRCULAR)
      (DESC "Circular Driveway")
      (LDESC
"This is the circular driveway in front of the house. Many cars are parked
here, and the drive is somewhat blocked. To the south is a stand of oaks,
to the north is the front porch of the house. Piled along the border of
the driveway are hundreds of pumpkins. Many of them are carved and lighted,
others unadorned.")
      (NORTH TO PORCH)
      (UP TO PORCH)
      (EAST TO OUTSIDE)
      (WEST TO WEST-OF-HOUSE)
      (STATION CIRCLE)
      (LINE 4 ;OUTSIDE-LINE-C)
      (PSEUDO "OAKS" OAKS-PSEUDO)>

<ROUTINE OAKS-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The oaks are ancient, stately, and wet." CR>)>>

<OBJECT PUMPKIN
	(IN CIRCLE)
	(DESC "pumpkin")
	(SYNONYM PUMPKIN O\'LANTERN)
	(ADJECTIVE JACK)
	(FLAGS NDESCBIT TRYTAKEBIT TAKEBIT)
	(ACTION PUMPKIN-F)>

<ROUTINE PUMPKIN-F ()
	 <COND (<VERB? EXAMINE>
		<TELL

"There are hundreds of them. Grotesque demon faces conceal themselves in
the pile, and leering skulls stare this way and that. Some of the
candles have gone out from the rain, and those pumpkins sit forlorn and
wet, huddling together for warmth." CR>)
	       (<VERB? TAKE>
		<TELL 
"Taking a pumpkin from the pile could bring them all crashing down." CR>)>>

<ROOM PORCH
      (IN ROOMS)
      (SYNONYM PORCH)
      (ADJECTIVE FRONT)
      (DESC "Front Porch")
      (LDESC
"This is a screened porch covering much of the front of the house.
There are potted plants and lawn chairs arranged to suggest
conversational groupings. To the south you can see the circular
driveway, and beyond, barely visible in the rain and fog, is
a stand of oaks which screen the house on this side.
The front lights are on, and the doorbell to the left of the front
door is clearly visible.")
      (NORTH TO HALL IF FRONT-DOOR IS OPEN)
      (IN TO HALL IF FRONT-DOOR IS OPEN)
      (DOWN TO CIRCLE)
      (SOUTH TO CIRCLE)
      (STATION CIRCLE)
      (GLOBAL FRONT-DOOR GLOBAL-CHAIR GLOBAL-PLANTS)
      (LINE 4 ;OUTSIDE-LINE-C)
      (PSEUDO "OAKS" OAKS-PSEUDO)>

<OBJECT FRONT-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "front door")
	(SYNONYM DOOR)
	(ADJECTIVE FRONT)
	(UNLOCK HALL)
	(ACTION FRONT-DOOR-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT LOCKED)>

<ROUTINE FRONT-DOOR-F ()
	 <COND (<VERB? OPEN REPLY>
		<COND (<AND <IN? ,NEW-ARRIVAL ,PORCH>
			    <EQUAL? ,HERE ,HALL>>
		       <FSET ,FRONT-DOOR ,OPENBIT>
		       <FCLEAR ,FRONT-DOOR ,LOCKED>
		       <NEW-ARRIVAL-STUFF ,PLAYER>
		       <RTRUE>)
		      (<AND <EQUAL? ,HERE ,PORCH>
			    <FSET? ,FRONT-DOOR ,LOCKED>>
		       <TELL
CTHE ,FRONT-DOOR " is locked. Perhaps if you rang " THE ,GLOBAL-DOORBELL
" someone would answer it." CR>)>)>>

<OBJECT GLOBAL-DOORBELL
	(IN GLOBAL-OBJECTS)
	(DESC "doorbell")
	(SYNONYM DOORBELL BELL)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-DOORBELL-F)>

<ROUTINE TELL-ABOUT-DUFFY ()
	 <TELL
" A uniformed policeman accompanies " THE ,DETECTIVE ". \"This is " 'DUFFY ",
my assistant. You may say anything to him that you would say to me. "
,AMBULANCE-COMING ",\" adds " THE ,DETECTIVE "." CR>
	 <G-DETECTIVE ,G-REACHED>
	 <G-DUFFY ,G-REACHED>>

<GLOBAL AMBULANCE-COMING "The ambulance will be along soon">

<ROUTINE GLOBAL-DOORBELL-F ()
	 <COND (<VERB? REPLY>
		<COND (<NOT ,NEW-ARRIVAL>
		       <TELL
"I didn't realize anyone had rung the doorbell recently." CR>)
		      (<EQUAL? ,HERE ,HALL>
		       <TELL
"That's the butler's job. But if you insist..." CR>
		       <COND (<IN? ,NEW-ARRIVAL ,PORCH>
			      <NEW-ARRIVAL-STUFF ,PLAYER>
			      <RTRUE>)
			     (ELSE
			      <THERE-DOESNT-SEEM>
			      <TELL "anyone there." CR>)>)
		      (ELSE
		       <TELL
,YOU-ARENT "at the front door." CR>)>)>>

<ROUTINE NEW-ARRIVAL-STUFF (WHO "AUX" L (FLG <>) (DET? <>) (ALI? <>) (PLA? <>))
	 <COND (,NEW-ARRIVAL
		<FCLEAR ,FRONT-DOOR ,LOCKED>
		<COND (<AND <EQUAL? ,HERE ,PORCH>
			    <NOT ,PLAYER-HIDING>>
		       <SET PLA? T>
		       <SETG NEW-ARRIVAL ,PLAYER>
		       <MOVE-PLAYER ,HALL>
		       <USL>)>
		<COND (<IN? ,ALICIA ,PORCH>
		       <SET ALI? T>
		       <SETG NEW-ARRIVAL ,ALICIA>
		       <MOVE ,ALICIA ,HALL>
		       <ESTABLISH-GOAL ,ALICIA ,BALLROOM-5>)>
		<COND (<IN? ,DETECTIVE ,PORCH>
		       <SET DET? T>
		       <SETG NEW-ARRIVAL ,DETECTIVE>
		       <MOVE ,DETECTIVE ,HALL>
		       <MOVE ,DUFFY ,HALL>
		       <NEW-SCRIPT ,DETECTIVE ,DETECTIVE-SCRIPT>
		       <NEW-SCRIPT ,DUFFY ,DUFFY-SCRIPT>)>
		<COND (<EQUAL? .WHO ,PLAYER>
		       <SET FLG T>
		       <COND (.DET?
			      <TELL
CTHE ,DETECTIVE " enters the house, looking about cautiously. A few curt
words of greeting are uttered.">
			      <TELL-ABOUT-DUFFY>)>
		       <COND (.ALI?
			      <ALICIA-DESC-F>
			      <TELL
'ALICIA " enters the house, thanking you for answering the
doorbell." CR>
			      <WHERE-UPDATE ,ALICIA T>)>)
		      (T ;"BUTLER"
		       <SET L <LOC ,BUTLER>>
		       <COND (<AND <EQUAL? .L ,HALL ,PORCH>
				   <EQUAL? ,HERE ,HALL ,PORCH>>
			      <SET FLG T>
			      <TELL 'BUTLER " opens the front door.">
			      <COND (.PLA?
				     <TELL
" He ushers you into the hall. It is clear
from his demeanor that he remembers letting you in earlier in the evening,
but he suppresses his perplexity reasonably well.">)>
			      <COND (<OR .ALI? .DET?>
				     <TELL
" He greets ">
				     <COND (<AND .ALI? .DET?>
					    <TELL "everyone">)
					   (ELSE
					    <TELL D ,NEW-ARRIVAL>)>
				     <TELL ", his gorilla
costume eliciting a glance of suppressed amusement, and ushers the new
arrival into the front hall.">)>
			      <COND (.DET?
				     <TELL-ABOUT-DUFFY>)
				    (ELSE <CRLF>)>
			      <COND (.ALI?
				     <WHERE-UPDATE ,ALICIA T>)>)>)>
		<SETG NEW-ARRIVAL <>>
		.FLG)>>

<OBJECT DOORBELL
	(IN PORCH)
	(DESC "front doorbell")
	(SYNONYM DOORBELL BELL)
	(ADJECTIVE FRONT)
	(FLAGS NDESCBIT)
	(ACTION DOORBELL-F)>

<ROUTINE DOORBELL-F ()
	 <COND (<VERB? PUSH RING>
		<SETG NEW-ARRIVAL ,PLAYER>
		<ESTABLISH-GOAL ,BUTLER ,HALL T>
		<TELL "The doorbell rings." CR>)>>

<ROOM HALL
      (IN ROOMS)
      (SYNONYM HALL ENTRY)
      (ADJECTIVE FRONT ENTRY)
      (DESC "Entry Hall")
      (LDESC
"The front entry hall is dominated by two curving staircases which
lead up to the second floor of the house. These have velvet ribbons
across them to keep the guests downstairs. In addition to the front
door, which goes out to the porch, there are large double doors
leading north and smaller doors leading east and west. The
entry is sparsely furnished, imposing but not overpowering.")
      (NORTH TO HALLWAY-9)
      (EAST TO LIBRARY IF LH-DOOR IS OPEN)
      (WEST TO MORNING-ROOM IF MH-DOOR IS OPEN)
      (SOUTH TO PORCH IF FRONT-DOOR IS OPEN)
      (NE "There is a red velvet ribbon politely barring the way.")
      (NW "There is a red velvet ribbon politely barring the way.")
      (UP "There is a red velvet ribbon politely barring the way.")
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-9)
      (GLOBAL WINDOW CURTAINS LH-DOOR MH-DOOR FRONT-DOOR STAIR VELVET-RIBBON)>

<OBJECT VELVET-RIBBON
	(IN LOCAL-GLOBALS)
	(DESC "velvet ribbon")
	(SYNONYM RIBBON)
	(ADJECTIVE RED VELVET)
	(ACTION VELVET-RIBBON-F)
	(FLAGS NDESCBIT)>

<ROUTINE VELVET-RIBBON-F ()
	 <COND (<VERB? THROUGH CUT>
		<TELL "That would be bad manners." CR>)>>

<OBJECT LH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "east entry hall door")
	(SYNONYM DOOR)
	(ADJECTIVE EAST ENTRY HALL)
	(UNLOCK LIBRARY)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT MH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "west entry hall door")
	(SYNONYM DOOR)
	(ADJECTIVE WEST ENTRY HALL)
	(UNLOCK MORNING-ROOM)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<ROOM MORNING-ROOM
      (IN ROOMS)
      (SYNONYM ROOM)
      (ADJECTIVE MORNING)
      (DESC "Morning Room")
      (LDESC
"This room is set up for receiving guests, casual conversation, and
informal entertaining. Doors lead east to the entry hall and north to
the hallway. Several windows grace the southern wall, and a telephone
sits on a walnut secretary in one corner.")
      (EAST TO HALL IF MH-DOOR IS OPEN)
      (NORTH TO HALLWAY-3 IF MORNING-ROOM-DOOR IS OPEN)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-3)
      (GLOBAL WINDOW CURTAINS TELEPHONE MORNING-ROOM-DOOR MH-DOOR)>

<OBJECT WRITING-DESK
	(IN MORNING-ROOM)
	(SYNONYM SECRETARY DESK)
	(ADJECTIVE WRITING WALNUT)
	(DESC "secretary")
	(FLAGS NDESCBIT CONTBIT FURNITURE)
	(CAPACITY 50)>

<OBJECT WINDOW-SEAT
	(IN MORNING-ROOM)
	(SYNONYM SEAT)
	(ADJECTIVE WINDOW)
	(DESC "window seat")
	(DESCFCN WINDOW-SEAT-DESC-F)
	(ACTION WINDOW-SEAT-F)
	(FLAGS CONTBIT FURNITURE VEHBIT SURFACEBIT SEARCHBIT)
	(CAPACITY 200)>

<GLOBAL THERE-IS "There is ">

<ROUTINE WINDOW-SEAT-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL ,THERE-IS>
	 <COND (<FSET? ,WINDOW-SEAT ,OPENBIT>
		<TELL "an open ">)
	       (ELSE
		<TELL "a closed ">)>
	 <TELL 'WINDOW-SEAT " beneath one of the windows." CR>>

<ROUTINE WINDOW-SEAT-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <VERB? STAND DISEMBARK>
			    <IN? ,WINNER ,WINDOW-SEAT>
			    ,PLAYER-HIDING>
		       <FSET ,WINDOW-SEAT ,OPENBIT>
		       <RFALSE>)
		      (<AND <VERB? LOOK EXAMINE> ,PLAYER-HIDING>
		       <TELL-CANT-SEE "because you're hiding!">
		       <CRLF>)
		      (<AND <VERB? LOOK-INSIDE> ,PLAYER-HIDING>
		       <TELL "There isn't much to see." CR>)>)
	       (.RARG <RFALSE>)
	       (<VERB? OPEN>
		<COND (<AND <IN? ,WINNER ,WINDOW-SEAT>
			    <FSET? ,WINDOW-SEAT ,SURFACEBIT>>
		       <TELL-GET-UP>)
		      (T
		       <FCLEAR ,PRSO ,SURFACEBIT>
		       <COND (,PLAYER-HIDING <PLAYER-EMERGES>)>
		       <RFALSE>)>)
	       (<AND <VERB? CLOSE> <FSET? ,PRSO ,OPENBIT>>
		<FSET ,PRSO ,SURFACEBIT>
		<FCLEAR ,PRSO ,OPENBIT>
		<TELL "Closed." CR>)
	       (<AND <VERB? SIT> <FSET? ,PRSO ,OPENBIT>>
		<TELL-YOU-CANT
"sit on an open " <>>
		<TELL D ,PRSO "." CR>)
	       (<VERB? THROUGH HIDE-INSIDE>
		<COND (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <TELL-YOU-CANT
"get in a closed " <>> <TELL D ,PRSO "." CR>)
		      (<IN? ,CORPSE ,WINDOW-SEAT>
		       <TELL
"That would be too crowded for comfort." CR>)
		      (<NOT ,PLAYER-HIDING>
		       <FCLEAR ,WINDOW-SEAT ,OPENBIT>
		       <MOVE ,PLAYER ,WINDOW-SEAT>
		       <SETG PLAYER-HIDING ,WINDOW-SEAT>
		       <TELL
,YOU-ARE "now hiding in the " 'WINDOW-SEAT "." CR>)>)
	       (<AND <VERB? PUT>
		     ,PRSI
		     <NOT <FSET? ,PRSI ,OPENBIT>>>
		<TELL ,YOU-MUST "open the " 'WINDOW-SEAT " first." CR>)
	       (<AND <VERB? PUT> <EQUAL? ,PRSO ,CORPSE>>
		<TELL
"Your name wouldn't be Brewster, by any chance?" CR>
		<RFALSE>)
	       (<VERB? EXAMINE>
		<TELL
"A " 'WINDOW-SEAT " is a bench underneath a window that often has storage
space inside it. This one overlooks the front of the house and down the hill.
In \"Arsenic and Old Lace,\" there were several bodies hidden in "
A ,WINDOW-SEAT "." CR>)>>

<OBJECT MORNING-ROOM-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "morning room door")
	(SYNONYM DOOR)
	(ADJECTIVE MORNING)
	(UNLOCK MORNING-ROOM)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<ROOM SITTING-ROOM
      (IN ROOMS)
      (SYNONYM ROOM)
      (ADJECTIVE SITTING)
      (DESC "Sitting Room")
      (LDESC
"This is Ms. Ashcroft's sitting room. The room in furnished with formal
but comfortable looking chairs, a small couch, and a large oriental
rug. A telephone is on one end table. The door is to the north and leads
back into the hall.")
      (NORTH TO HALLWAY-1 IF SITTING-ROOM-DOOR IS OPEN)
      (STATION HALLWAY-1)
      (LINE 0 ;HALL-LINE-C)
      (GLOBAL WINDOW CURTAINS TELEPHONE GLOBAL-CHAIR
       	      GLOBAL-SOFA GLOBAL-RUG)>

<OBJECT END-TABLE
	(IN SITTING-ROOM)
	(DESC "end table")
	(SYNONYM TABLE)
	(ADJECTIVE END)
	(ACTION VARIOUS-TABLES-F)
	(CAPACITY 20)
	(FLAGS NDESCBIT FURNITURE VEHBIT TRYTAKEBIT TAKEBIT
	       SURFACEBIT OPENBIT CONTBIT)>

<OBJECT SITTING-ROOM-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "sitting room door")
	(SYNONYM DOOR)
	(ADJECTIVE SITTING)
	(UNLOCK SITTING-ROOM)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<ROOM HALLWAY-1
      (IN ROOMS)
      (DESC "West End of Hallway")
      (LDESC
"This is the west end of the main hallway. To the west is a door leading
out of the house, and there are also doors north and south.")
      (EAST TO HALLWAY-2)
      (WEST TO WEST-OF-HOUSE IF WEST-DOOR IS OPEN)
      (NORTH TO MEDIA-ROOM IF MEDIA-ROOM-DOOR IS OPEN)
      (SOUTH TO SITTING-ROOM IF SITTING-ROOM-DOOR IS OPEN)
      (GLOBAL WEST-DOOR MEDIA-ROOM-DOOR WINDOW CURTAINS SITTING-ROOM-DOOR)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-1)
      (CORRIDOR 1)>

<ROOM HALLWAY-2
      (IN ROOMS)
      (DESC "Hall Near Bath")
      (LDESC
"Near the west end of the hallway, doors lead north to a
bathroom and south to a linen closet.")
      (EAST TO HALLWAY-3)
      (WEST TO HALLWAY-1)
      (NORTH TO WEST-BATH IF WEST-BATH-DOOR IS OPEN)
      (SOUTH TO LINEN-CLOSET IF LINEN-CLOSET-DOOR IS OPEN)
      (GLOBAL LINEN-CLOSET-DOOR WEST-BATH-DOOR)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-2)
      (CORRIDOR 1)>

<ROOM HALLWAY-3
      (IN ROOMS)
      (DESC "Hall at Office")
      (LDESC
"Off the hallway here are the office to the north and the morning room
to the south.")
      (EAST TO HALLWAY-4)
      (WEST TO HALLWAY-2)
      (NORTH TO OFFICE IF SOUTH-OFFICE-DOOR IS OPEN)
      (SOUTH TO MORNING-ROOM IF MORNING-ROOM-DOOR IS OPEN)
      (GLOBAL SOUTH-OFFICE-DOOR MORNING-ROOM-DOOR)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-3)
      (CORRIDOR 1)>

<ROOM HALLWAY-4
      (IN ROOMS)
      (DESC "Hall at Corner")
      (LDESC
"The hallway makes an elbow bend here. In the distance to the north and
west are doors leading outside. North of here another hall leads
east.")
      (WEST TO HALLWAY-3)
      (NORTH TO HALLWAY-5)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-4)
      (CORRIDOR %<+ 1 2>)>

<ROOM HALLWAY-5
      (IN ROOMS)
      (DESC "Hallway Intersection")
      (LDESC
"Here a north-south hallway and a hallway to the east meet.")
      (EAST TO HALLWAY-8)
      (NORTH TO HALLWAY-6)
      (SOUTH TO HALLWAY-4)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-5)
      (CORRIDOR %<+ 2 4>)>

<ROOM HALLWAY-6
      (IN ROOMS)
      (DESC "Hall Near Coat Closet")
      (LDESC
"This is a north-south hallway leading to an outer door further north.
To the east is a coat closet.")
      (EAST TO WEST-COAT-CLOSET IF WEST-CLOSET-DOOR IS OPEN)
      (NORTH TO HALLWAY-7)
      (SOUTH TO HALLWAY-5)
      (LINE 3 ;GARAGE-LINE-C)
      (STATION HALLWAY-6)
      (GLOBAL WEST-CLOSET-DOOR)
      (CORRIDOR 2)>

<ROOM WEST-COAT-CLOSET
      (IN ROOMS)
      (SYNONYM CLOSET)
      (ADJECTIVE COAT WEST)
      (DESC "West Coat Closet")
      (LDESC
"This is a walk-in coat closet that doesn't seem to be in use this
evening.")
      (WEST TO HALLWAY-6 IF WEST-CLOSET-DOOR IS OPEN)
      (STATION HALLWAY-6)
      (GLOBAL WEST-CLOSET-DOOR)
      (LINE 3 ;GARAGE-LINE-C)>

<OBJECT WEST-CLOSET-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "west closet door")
	(SYNONYM DOOR)
	(ADJECTIVE WEST CLOSET)
	(UNLOCK ROOMS) ;"no lock"
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT HAMPER
	(IN WEST-COAT-CLOSET)
	(SYNONYM HAMPER)
	(ADJECTIVE LARGE WICKER)
	(DESC "wicker hamper")
	(DESCFCN HAMPER-DESC-F)
	(ACTION HAMPER-F)
	(FLAGS TAKEBIT BURNBIT CONTBIT)
	(SIZE 30)
	(CAPACITY 100)>

<ROUTINE HAMPER-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <VERB? PUT>
		     <EQUAL? ,PRSO ,HAMPER>
		     <EQUAL? ,PRSI ,WINDOW-SEAT ,BMW-TRUNK ,MERCEDES-TRUNK>>
		<TELL "It's too big." CR>)>>

<ROUTINE HAMPER-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL ,THERE-IS "a large wicker hamper ">
	 <COND (<IN? ,HAMPER ,WEST-COAT-CLOSET>
		<TELL
"at one end of the closet.">)
	       (ELSE
		<TELL
"here.">)>
	 <COND (<FSET? ,HAMPER ,OPENBIT>
		<TELL " The hamper is open.">)>
	 <CRLF>>

<ROOM HALLWAY-7
      (IN ROOMS)
      (DESC "North Hall")
      (LDESC
"The north end of the hall, at an outer door. A landing leading to a stairway
is east. You can see a covered walkway through a
jalousied door to the north.")
      (EAST "There is a red velvet ribbon politely barring the way.")
      (UP "There is a red velvet ribbon politely barring the way.")
      (NORTH TO WALKWAY IF NORTH-DOOR IS OPEN)
      (SOUTH TO HALLWAY-6)
      (GLOBAL NORTH-DOOR WINDOW STAIR VELVET-RIBBON)
      (LINE 3 ;GARAGE-LINE-C)
      (STATION HALLWAY-7)
      (CORRIDOR 2)>

<ROOM HALLWAY-8
      (IN ROOMS)
      (DESC "Front Hall West")
      (LDESC
"The front hall runs south of the living room here, and a large doorway
opens north into that room. East and south is the way back into the
entry hall. Another hall intersects to the west.")
      (EAST TO HALLWAY-9)
      (WEST TO HALLWAY-5)
      (NORTH TO LIVING-ROOM)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-8)
      (CORRIDOR 4)>

<ROOM HALLWAY-9
      (IN ROOMS)
      (DESC "Front Hall")
      (LDESC
"This is the front hall, which runs east and west.  Entrances to the
living room are east and west of here, and the entry hall is to the
south.")
      (EAST TO HALLWAY-10)
      (WEST TO HALLWAY-8)
      (SOUTH TO HALL)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-9)
      (CORRIDOR 4)>

<ROOM HALLWAY-10
      (IN ROOMS)
      (DESC "Front Hall East")
      (LDESC
"The front hall runs past an entrance to the living room here, to the
north. Another hall intersects to the east.")
      (EAST TO HALLWAY-11)
      (WEST TO HALLWAY-9)
      (NORTH TO LIVING-ROOM)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-10)
      (CORRIDOR 4)>

<ROOM HALLWAY-11
      (IN ROOMS)
      (DESC "Long Hall Begins")
      (LDESC
"Here the front hall and a long north-south hall fronting the ballroom
intersect. Another hall starts south of here and goes east.")
      (WEST TO HALLWAY-10)
      (NORTH TO HALLWAY-12)
      (SOUTH TO HALLWAY-16)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-11)
      (CORRIDOR %<+ 4 8>)>

<ROOM HALLWAY-12
      (IN ROOMS)
      (DESC "Long Hall South")
      (LDESC
"This is almost the southern end of the long north-south hall. A large doorway
opens into the southern end of the ballroom. Another door on the west is to a
small closet.")
      (EAST TO BALLROOM-7)
      (WEST TO EAST-COAT-CLOSET IF EAST-CLOSET-DOOR IS OPEN)
      (NORTH TO HALLWAY-13)
      (SOUTH TO HALLWAY-11)
      (ACTION HALLWAY-12-F)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-12)
      (GLOBAL EAST-CLOSET-DOOR)
      (CORRIDOR %<+ 8 128>)>

<ROOM EAST-COAT-CLOSET
      (IN ROOMS)
      (SYNONYM CLOSET)
      (ADJECTIVE COAT EAST)
      (DESC "East Coat Closet")
      (LDESC
"This is a large coat closet full of rather damp coats, overcoats, and
raincoats.")
      (EAST TO HALLWAY-12 IF EAST-CLOSET-DOOR IS OPEN)
      (STATION HALLWAY-12)
      (LINE 0 ;HALL-LINE-C)
      (GLOBAL EAST-CLOSET-DOOR)
      (PSEUDO "COATS" COATS-PSEUDO "RAINCOAT" COATS-PSEUDO)>

<OBJECT EAST-CLOSET-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "east closet door")
	(SYNONYM DOOR)
	(ADJECTIVE EAST CLOSET)
	(UNLOCK ROOMS) ;"no lock"
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT OPENBIT NDESCBIT)>

<ROUTINE COATS-PSEUDO ()
	 <COND (<VERB? SEARCH EXAMINE>
		<TELL
"There are too many. ">
		<TELL-SPECIFIC>)
	       (<VERB? TAKE>
		<TELL "That would be stealing!" CR>)>>

<GLOBAL SLAPSTICK? T>
<GLOBAL ENTANGLED? <>>

<ROUTINE I-UNTANGLE ()
	 <SETG ENTANGLED? <>>
	 <MOVE ,GUEST ,GLOBAL-OBJECTS>
	 <PUT <GET ,GOAL-TABLES ,BUTLER-C> ,ATTENTION 0>
	 <ESTABLISH-GOAL ,BUTLER ,BALLROOM-8 T>
	 <TELL
'BUTLER " regains his composure, and helps you to your feet, apologizing
profusely. \"I've gotten your costume all dirty.
Permit me to straighten it.\" He removes a small brush from his suit,
straightens your vest, and brushes the dirt off. While " 'BUTLER " is
ministering to your costume, the other guest speedily and thankfully
departs the area." CR>>

<GLOBAL PLAYER-FOLLOWED-VERONICA? <>>

<ROUTINE HALLWAY-12-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <==? .RARG ,M-END>
		     <NOT ,SLAPSTICK?>
		     <IN? ,BUTLER ,HALLWAY-12>
		     <IN-MOTION? ,VERONICA>>
		<SETG PLAYER-FOLLOWED-VERONICA? T>
		<SETG SLAPSTICK? T>
		<SETG ENTANGLED? 1>
		<MOVE ,GUEST ,HALLWAY-12>
		<ESTABLISH-GOAL ,BUTLER ,BALLROOM-8>
		<GRAB-ATTENTION ,BUTLER>
		<ENABLE <QUEUE I-UNTANGLE 4>>
		<TELL

"You reach the vicinity of the coat closet, but you must weave your way
around the butler and a guest. " 'BUTLER " is taking the guest's coat to hang
it up, and the two of them are blocking the hall. The guest ">
<COND (<OR <IN? ,VERONICA ,HERE>
	   <CORRIDOR-LOOK ,VERONICA>>
       <TELL "turns to stare at " 'VERONICA " as she rushes "
	     <COND (<IN? ,VERONICA ,BALLROOM-7> "up")
		   (<IN? ,VERONICA ,HERE> "by")
		   (T "off")>
	     ", and ">)>
<TELL
"bumps you. Now " 'BUTLER ", whose
vision is not improved by the gorilla suit he is wearing, becomes
entangled in the guest's overcoat. Unfortunately, it's still attached to
the guest and the two of them nearly fall to the floor. You are
entangled in the confusion." CR>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <VERB? FOLLOW WALK STAND> ,ENTANGLED?>
		       <TELL <GET ,ENTANGLED-YUKS ,ENTANGLED?> CR>
		       <SETG ENTANGLED? <+ ,ENTANGLED? 1>>
		       <RTRUE>)>)>>

<GLOBAL ENTANGLED-YUKS
	<LTABLE
"You try to extricate yourself from the undignified tangle, but only
succeed in confusing matters more."

"Smythe almost succeeds in reaching his feet, but the guest pulls him
down again by trying to pull his coat back on."

"You succeed in regaining your feet.">>

<OBJECT GUEST
	(DESC "party guest")
	(SYNONYM GUEST DEVIL)
	(ADJECTIVE PARTY)
	(ACTION GUEST-F)
	(FLAGS NDESCBIT PERSON THE)>

<ROUTINE GUEST-F ()
	 <COND (<OR <EQUAL? ,GUEST ,WINNER>
		    <VERB? TELL>
		    <TALKING-TO? ,GUEST>>
		<COND (<VERB? TELL>
		       <SETG P-CONT <>>
		       <SETG QUOTE-FLAG <>>)>
		<TELL
"The guest is too busy dealing with his coat, the butler, and you to
answer coherently or civilly." CR>)
	       (<AND <VERB? EXAMINE> <IN? ,GUEST ,HERE>>
		<TELL
"The guest is rumpled and crumpled from the recent melee. He appears to
be wearing the remains of a devil costume. Fortunately, he has no
pitchfork." CR>)
	       (<AND <NOT <IN? ,GUEST ,HERE>>
		     <EQUAL? ,PLAYER ,WINNER>>
		<PERFORM ,V?FIND ,GUEST>
		<RTRUE>)>>

<ROOM HALLWAY-13
      (IN ROOMS)
      (DESC "Hall Near Ballroom")
      (LDESC
"This is the middle of the long hall. To the east is a large doorway
opening onto the ballroom, and to the west is a stairway leading up.")
      (EAST TO BALLROOM-4)
      (WEST "There is a red velvet ribbon politely barring the way.")
      (UP "There is a red velvet ribbon politely barring the way.")
      (NORTH TO HALLWAY-14)
      (SOUTH TO HALLWAY-12)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-13)
      (CORRIDOR %<+ 8 64>)
      (GLOBAL STAIR VELVET-RIBBON)>

<ROOM HALLWAY-14
      (IN ROOMS)
      (DESC "Long Hall North")
      (LDESC
"Near the north end of the long hall a doorway opens into the ballroom,
and to the west a sliding glass door opens out into the garden.")
      (EAST TO BALLROOM-1)
      (WEST TO GARDEN IF SLIDING-DOOR IS OPEN)
      (NORTH TO HALLWAY-15)
      (SOUTH TO HALLWAY-13)
      (FLAGS OPENBIT)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-14)
      (CORRIDOR %<+ 8 32>)
      (GLOBAL SLIDING-DOOR)>

<ROOM HALLWAY-15
      (IN ROOMS)
      (DESC "Hall at Dining Room")
      (LDESC
"This is the northern end of the hall, where a doorway leads to the
dining room.")
      (NORTH TO DINING-ROOM)
      (SOUTH TO HALLWAY-14)
      (LINE 0 ;HALL-LINE-C)
      (STATION HALLWAY-15)
      (CORRIDOR 8)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW)>

<ROOM HALLWAY-16
      (IN ROOMS)
      (DESC "East Hall")
      (LDESC
"This is the beginning of the east hall. North is the long front hall and
south is a door leading into the library. The hall continues to the
east.")
      (EAST TO HALLWAY-17)
      (NORTH TO HALLWAY-11)
      (SOUTH TO LIBRARY IF LIBRARY-DOOR IS OPEN)
      (GLOBAL LIBRARY-DOOR)
      (LINE 2 ;EAST-HALL-LINE-C)
      (STATION HALLWAY-16)
      (CORRIDOR %<+ 8 16>)>

<ROOM HALLWAY-17
      (IN ROOMS)
      (DESC "East Hall at Bath")
      (LDESC
"The east hall continues. To the south is a bathroom.")
      (EAST TO HALLWAY-19)
      (WEST TO HALLWAY-16)
      (SOUTH TO EAST-BATH IF EAST-BATH-DOOR IS OPEN)
      (GLOBAL EAST-BATH-DOOR)
      (LINE 2 ;EAST-HALL-LINE-C)
      (STATION HALLWAY-17)
      (CORRIDOR 16)>

<OBJECT EAST-BATH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "east bath door")
	(SYNONYM DOOR)
	(ADJECTIVE EAST BATH)
	(UNLOCK EAST-BATH)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT)>

<ROOM HALLWAY-19
      (IN ROOMS)
      (DESC "East Hall End")
      (LDESC
"The east hall ends here. A door opens to the outside and another opens
south to the sun room.")
      (EAST TO OUTSIDE IF EAST-DOOR IS OPEN)
      (WEST TO HALLWAY-17)
      (SOUTH TO SUN-ROOM IF SUN-ROOM-DOOR IS OPEN)
      (LINE 2 ;EAST-HALL-LINE-C)
      (STATION HALLWAY-19)
      (CORRIDOR 16)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW SUN-ROOM-DOOR EAST-DOOR)>

\

"Other inside rooms"

<ROOM MEDIA-ROOM
      (IN ROOMS)
      (SYNONYM ROOM)
      (ADJECTIVE MEDIA)
      (DESC "Media Room")
      (LDESC
"This is a large room with a projection TV and VCR at one end. Comfortable
chairs and sofa are grouped around it. A bookcase contains a large
library of videotapes. There is a telephone on the bookcase. The hallway
is to the south and on the east is a connecting door to the office.")
      (EAST TO OFFICE IF MEDIA-OFFICE-DOOR IS OPEN)
      (SOUTH TO HALLWAY-1 IF MEDIA-ROOM-DOOR IS OPEN)
      (GLOBAL MEDIA-OFFICE-DOOR WINDOW CURTAINS TELEPHONE
              MEDIA-ROOM-DOOR GLOBAL-SOFA GLOBAL-CHAIR)
      (STATION HALLWAY-1)
      (LINE 0 ;HALL-LINE-C)>

<OBJECT MEDIA-ROOM-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "media room door")
	(SYNONYM DOOR)
	(ADJECTIVE MEDIA ROOM)
	(UNLOCK MEDIA-ROOM)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT TELEVISION
	(IN MEDIA-ROOM)
	(DESC "projection TV")
	(SYNONYM TV TELEVISION)
	(ADJECTIVE PROJECTION)
	(ACTION TELEVISION-F)
	(FLAGS NDESCBIT ONBIT)>

<ROUTINE TELEVISION-F ()
	 <COND (<VERB? EXAMINE>
		<COND (<FSET? ,PRSO ,ONBIT>
		       <TELL
"The TV is on, tuned to the Cable News Network." CR>)
		      (T
		       <TELL "The TV is off." CR>)>)
	       (<VERB? LAMP-ON>
		<TELL "It's already on." CR>)
	       (<VERB? LAMP-OFF>
		<TELL "Don't you like to watch?" CR>)>>

<OBJECT VCR
	(IN MEDIA-ROOM)
	(DESC "VCR")
	(SYNONYM VCR RECORD)
	(ADJECTIVE VIDEO CASSETTE)
	(ACTION VCR-F)
	(FLAGS NDESCBIT)>

<ROUTINE VCR-F ()
	 <COND (<VERB? EXAMINE LAMP-ON LAMP-OFF>
		<TELL
"This is a kind you've never seen before, and you
can't fathom its controls. It's made by the Frobozz Magic
VCR Company." CR>)>>

<OBJECT BOOKCASE
	(IN MEDIA-ROOM)
	(DESC "bookcase")
	(SYNONYM BOOKCASE SHELVES SHELF)
	(ACTION BOOKCASE-F)
	(FLAGS NDESCBIT OPENBIT CONTBIT)
	(CAPACITY 50)>

<ROUTINE BOOKCASE-F ()
	 <COND (<VERB? LOOK-INSIDE EXAMINE>
		<TELL
"The bookcase contains ">
		<COND (<PRINT-CONTENTS ,BOOKCASE <> ,VIDEOTAPE>
		       <TELL " and ">)>
		<TELL "many videotapes." CR>)>>

<OBJECT VIDEOTAPE
	(IN BOOKCASE)
	(DESC "videotape")
	(SYNONYM VIDEOTAPE TAPES)
	(FLAGS NDESCBIT)>

<ROOM OFFICE
      (IN ROOMS)
      (SYNONYM OFFICE)
      (DESC "Office")
      (WEST TO MEDIA-ROOM IF MEDIA-OFFICE-DOOR IS OPEN)
      (SOUTH TO HALLWAY-3 IF SOUTH-OFFICE-DOOR IS OPEN)
      (NORTH TO WALKWAY IF NORTH-OFFICE-DOOR IS OPEN)
      (ACTION OFFICE-F)
      (STATION HALLWAY-3)
      (LINE 0 ;HALL-LINE-C)
      (GLOBAL MEDIA-OFFICE-DOOR NORTH-OFFICE-DOOR SOUTH-OFFICE-DOOR
       TELEPHONE WINDOW CURTAINS)
      (PSEUDO "RUG" RUG-F "BOOKS" BOOKS-PSEUDO)>

<OBJECT MEDIA-OFFICE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "west office door")
	(SYNONYM DOOR)
	(ADJECTIVE EAST WEST OFFICE CONNECTING)
	(UNLOCK OFFICE)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT LOCKED NDESCBIT)>

<OBJECT NORTH-OFFICE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "north office door")
	(SYNONYM DOOR)
	(ADJECTIVE NORTH OFFICE)
	(UNLOCK OFFICE)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT LOCKED)>

<OBJECT SOUTH-OFFICE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "south office door")
	(SYNONYM DOOR)
	(ADJECTIVE SOUTH OFFICE)
	(UNLOCK OFFICE)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT LOCKED)>

<GLOBAL HAVE-DRAWERS-OPEN " have their drawers open.">

<GLOBAL PLAYER-BEEN-TO-OFFICE? <>>

<ROUTINE OFFICE-F ("OPTIONAL" (RARG <>))
	<COND (<==? .RARG ,M-LOOK>
	       <SETG PLAYER-BEEN-TO-OFFICE? T>
	       <TELL
"This is the farm's office. There are filing cabinets, a large and a
small desk, a personal computer, a telephone, a copier, and other expected
office
appointments. There are shelves with breeding books and other horsey
reference works. Where shelves don't cover the walls, ribbons and
prize certificates do. All this is overshadowed by the condition of the
room: papers are scattered everywhere, file folders spill their contents
on the floor and on every horizontal surface, a file of floppy disks has
been bounced off one wall, and copier toner is spilled on the rug. ">
	       <COND (<AND <FSET? ,LARGE-DESK ,OPENBIT>
			   <FSET? ,SMALL-DESK ,OPENBIT>
			   <FSET? ,FILE-CABINET ,OPENBIT>>
		      <TELL
"The desks and " 'FILE-CABINET ,HAVE-DRAWERS-OPEN>)
		     (<AND <FSET? ,LARGE-DESK ,OPENBIT>
			   <FSET? ,SMALL-DESK ,OPENBIT>>
		      <TELL
"The desks" ,HAVE-DRAWERS-OPEN>)
		     (<AND <FSET? ,LARGE-DESK ,OPENBIT>
			   <FSET? ,FILE-CABINET ,OPENBIT>>
		      <TELL
CTHE ,LARGE-DESK " and " THE ,FILE-CABINET ,HAVE-DRAWERS-OPEN>)
		     (<AND <FSET? ,SMALL-DESK ,OPENBIT>
			   <FSET? ,FILE-CABINET ,OPENBIT>>
		      <TELL
CTHE ,SMALL-DESK " and " THE ,FILE-CABINET ,HAVE-DRAWERS-OPEN>)
		     (<FSET? ,LARGE-DESK ,OPENBIT>
		      <TELL-HAS-DRAWER-OPEN ,LARGE-DESK>)
		     (<FSET? ,SMALL-DESK ,OPENBIT>
		      <TELL-HAS-DRAWER-OPEN ,SMALL-DESK>)
		     (<FSET? ,FILE-CABINET ,OPENBIT>
		      <TELL
CTHE ,FILE-CABINET " has its drawers open.">)
		     (T <TELL "The desk and file drawers are closed.">)>
	       <TELL " Doors lead out to the north, west, and south." CR>)>>

;<ROUTINE HAS-ON-IT (OBJ)
	 <COND (<FIRST? .OBJ>
		<TELL " " CTHE .OBJ " has on it ">
		<PRINT-CONTENTS .OBJ>
		<TELL ".">)>>

<ROUTINE TELL-HAS-DRAWER-OPEN (DESK)
	 <TELL
CTHE .DESK " has its drawer open.">>

<OBJECT LARGE-DESK
	(IN OFFICE)
	(DESC "large desk")
	(SYNONYM DESK)
	(ADJECTIVE LARGE)
	(CAPACITY 100)
	(ACTION DESK-F)
	(FLAGS CONTBIT SURFACEBIT OPENBIT NDESCBIT SEARCHBIT)>

<OBJECT SMALL-DESK
	(IN OFFICE)
	(DESC "small desk")
	(SYNONYM DESK)
	(ADJECTIVE SMALL)
	(CAPACITY 75)
	(ACTION DESK-F)
	(FLAGS CONTBIT SURFACEBIT OPENBIT NDESCBIT SEARCHBIT)>

<ROUTINE DESK-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL
,THERE-IS "nothing inside " THE ,PRSO ". It has all been dumped on the
floor." CR>)
	       (<AND <VERB? LOOK-BEHIND>
		     <EQUAL? ,PRSO ,LARGE-DESK>
		     <NOT <FSET? ,CORPSE ,TOUCHBIT>>>
		<PERFORM ,V?EXAMINE ,CORPSE>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<OPEN-CLOSE>)>>

<OBJECT FILE-CABINET
	(IN OFFICE)
	(DESC "file cabinet")
	(SYNONYM CABINET)
	(ADJECTIVE FILE FILES)
	(ACTION DESK-F)
	(FLAGS CONTBIT OPENBIT NDESCBIT)>

<OBJECT TRASH
	(IN OFFICE)
	(DESC "trash")
	(SYNONYM TRASH PAPERS SHELVES SHELF)
	(ADJECTIVE PAPER)
	(FLAGS NDESCBIT)
	(ACTION TRASH-F)>

<ROUTINE TRASH-F ()
	 <COND (<VERB? EXAMINE SEARCH LOOK-INSIDE>
		<TELL
"An incredible mess has been made of the records in this office. The
things on the floor alone would take days to sort out." CR>)>>

<OBJECT OFFICE-JUNK
	(IN OFFICE)
	(SYNONYM TONER PRIZES RIBBON PRIZE)
	(DESC "office debris")
	(ACTION OFFICE-JUNK-F)
	(FLAGS NDESCBIT READBIT)>

<ROUTINE OFFICE-JUNK-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL
"Examining it only makes you more aware of what a mess everything is." CR>)
	       (<VERB? TAKE>
		<TELL
"Carrying such junk would be a waste of effort." CR>)>>

<OBJECT COMPUTER
	(IN OFFICE)
	(SYNONYM COMPUTER)
	(ADJECTIVE PERSONAL)
	(DESC "computer")
	(ACTION COMPUTER-F)
	(CAPACITY 10)
	(FLAGS NDESCBIT CONTBIT OPENBIT)>

<ROUTINE COMPUTER-F ()
	 <COND (<VERB? LAMP-ON EXAMINE>
		<TELL "Whoever smashed things up wrecked this as well." CR>)
	       (<VERB? TAKE>
		<TELL "It's attached with a theft prevention bolt." CR>)>>

<OBJECT DISK
	(IN OFFICE)
	(SYNONYM DISKS FLOPPIES DISK)
	(ADJECTIVE FLOPPY)
	(DESC "disk")
	(ACTION DISK-F)
	(FLAGS NDESCBIT TRYTAKEBIT TAKEBIT READBIT)
	(TEXT
"By coincidence, one of the floppy disks is a copy of the computer
mystery \"Suspect.\"")>

<ROUTINE DISK-F ()
	 <COND (<VERB? TAKE>
		<TELL
"Unfortunately, they are all bent, mangled, and useless." CR>)>>

<OBJECT SALE
	(IN GLOBAL-OBJECTS)
	(SYNONYM SALE)
	(ADJECTIVE FARM)
	(DESC "sale")
	(FLAGS NDESCBIT)>

<OBJECT SALE-FOLDER
	(IN LARGE-DESK)
	(DESC "manila folder")
	(SYNONYM FOLDER)
	(ADJECTIVE MANILA PURCHASE SALE FILE)
	(ACTION SALE-FOLDER-F)
	(CAPACITY 10)
	(FLAGS READBIT CONTBIT TAKEBIT BURNBIT)>

<OBJECT SALE-AGREEMENT
	(IN SALE-FOLDER)
	(DESC "purchase and sale agreement")
	(SYNONYM AGREEMENT)
	(ADJECTIVE PURCHASE SALE)
	(ACTION SALE-AGREEMENT-F)
	(FLAGS NDESCBIT READBIT TAKEBIT TRYTAKEBIT BURNBIT)>

<ROUTINE SALE-FOLDER-F ()
	 <COND (<VERB? EXAMINE READ LOOK-INSIDE OPEN>
		<TELL
"The folder is labelled \"Sale of Ashcroft Farm.\"">
		<COND (<IN? ,SALE-AGREEMENT ,SALE-FOLDER>
		       <FCLEAR ,SALE-AGREEMENT ,NDESCBIT>
		       <FSET ,SALE-FOLDER ,OPENBIT>
		       <TELL " Inside"> <TELL-P&S>)>
		<CRLF>)>>

<ROUTINE SALE-AGREEMENT-F ()
	 <COND (<FSET? ,SALE-AGREEMENT ,NDESCBIT>
		<TELL "What agreement?" CR>)
	       (<VERB? EXAMINE READ>
		<TELL "This document">
		<TELL-P&S>
		<CRLF>)>>

<ROUTINE TELL-P&S ()
<TELL " is " A ,SALE-AGREEMENT " between the Ashcroft Trust (in the
person of " 'VERONICA ") and
" 'OSTMANN " Properties, Sam " 'OSTMANN "'s building firm. The agreement is dated
today. It is not yet signed by either party.">>

<OBJECT TRUST
	(IN GLOBAL-OBJECTS)
	(DESC "trust")
	(SYNONYM TRUST)
	(ADJECTIVE ASHCROFT FAMILY)
	(FLAGS NDESCBIT)>

<OBJECT TRUST-FOLDER
	(DESC "trust folder")
	(SYNONYM FOLDER)
	(ADJECTIVE FILE TRUST)
	(ACTION TRUST-FOLDER-F)
	(FLAGS INVISIBLE READBIT CONTBIT TAKEBIT BURNBIT)>

<ROUTINE TRUST-FOLDER-F ()
	 <COND (<VERB? EXAMINE READ LOOK-INSIDE OPEN>
		<TELL
"The folder is labelled \"Ashcroft Family Trust.\"">
		<COND (<IN? ,TRUST-DOCUMENTS ,TRUST-FOLDER>
		       <FCLEAR ,TRUST-DOCUMENTS ,NDESCBIT>
		       <FSET ,TRUST-FOLDER ,OPENBIT>
		       <TELL " Inside is a thick " 'TRUST-DOCUMENTS ".">)>
		<CRLF>)>>

<OBJECT TRUST-DOCUMENTS
	(IN TRUST-FOLDER)
	(DESC "sheaf of documents")
	(SYNONYM DOCUMENTS PAPERS SHEAF)
	(ADJECTIVE TRUST)
	(ACTION TRUST-DOCUMENTS-F)
	(FLAGS NDESCBIT READBIT TAKEBIT TRYTAKEBIT BURNBIT MICHAELBIT)>

<ROUTINE TRUST-DOCUMENTS-F ()
	 <COND (<FSET? ,TRUST-DOCUMENTS ,NDESCBIT>
		<TELL "What " 'TRUST-DOCUMENTS "?" CR>)
	       (<VERB? EXAMINE READ LOOK-INSIDE>
		<TELL
"There are many documents in a stapled bunch. They all concern
business and financial matters. On top is a letter from an accounting
firm. It reads in part: \"While it is difficult to make explicit
judgements on the advisability of certain investments by the Ashcroft
Family Trust, we find a disturbing pattern. In the past ten years
almost twenty percent of the Trust
holdings have been placed in four companies, each of which is
a poor financial risk. As the accompanying documents
show, all four are controlled by Southeast Planning
Corporation: privately held, with chief
executive officer listed as Colonel Robert Marston.\" Curiously,
on the back of the bunch there is a paper corner left under the
staple where a sheet was torn off." CR>)>>

<OBJECT INVESTOR-LIST
	(IN MICHAEL)
	(DESC "sheet of paper")
	(SYNONYM LIST SHEET PAPER)
	(ADJECTIVE INVESTOR PAPER)
	(FLAGS READBIT TRYTAKEBIT TAKEBIT BURNBIT INVISIBLE MICHAELBIT)
	(ACTION LIST-F)
	(TEXT
"This paper is under the letterhead of an accounting firm. It reads:|
|
\"Supplement I. Investors in Southeast Planning Corporation.|
|
Colonel Robert Marston..50%|
Michael R. Wellman......50%\"")>

<ROUTINE LIST-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The piece of paper has one corner torn from it where
it was stapled to something." CR>)
	       (<AND <VERB? TAKE READ>
		     <IN? ,INVESTOR-LIST ,FIREPLACE>>
		<MOVE ,INVESTOR-LIST ,WINNER>
		<TELL
"You reach into the fireplace, heedless of your precious
skin, and grab the piece of paper just in time!" CR>)>>

<ROOM WALKWAY
      (IN ROOMS)
      (SYNONYM WALKWAY)
      (ADJECTIVE COVERED)
      (DESC "Covered Walkway")
      (LDESC
"This covered walkway extends east and west from the hallway door to
the garage. The garden is to the north, and a door to the office is
southwest.")
      (WEST TO GARAGE IF WALKWAY-DOOR IS OPEN)
      (SOUTH TO HALLWAY-7 IF NORTH-DOOR IS OPEN)
      (SW TO OFFICE IF NORTH-OFFICE-DOOR IS OPEN)
      (IN TO HALLWAY-7 IF NORTH-DOOR IS OPEN)
      (NORTH TO GARDEN)
      (GLOBAL NORTH-OFFICE-DOOR NORTH-DOOR WINDOW WALKWAY-DOOR)
      (LINE 3 ;GARAGE-LINE-C)
      (FLAGS OPENBIT)
      (STATION WALKWAY)>

<ROOM LIVING-ROOM
      (IN ROOMS)
      (SYNONYM ROOM)
      (ADJECTIVE LIVING)
      (DESC "Living Room")
      (LDESC
"This is a large and comfortable living room. The decor is formal, and
the stern faces of several generations of Ashcrofts peer down from
portraits above you. A pair of large doorways open out to the hall on the
south wall, flanking a marble fireplace. An ornately carved mantel surmounts
the fireplace. Wide windows peer out over the garden to the north. There
is a telephone on an end table to the right of the sofa.")
      (SE TO HALLWAY-10)
      (SW TO HALLWAY-8)
      (SOUTH "The doorways are at the southeast and southwest of the room.")
      (STATION HALLWAY-8)
      (LINE 0 ;HALL-LINE-C)
      (GLOBAL WINDOW CURTAINS TELEPHONE GLOBAL-SOFA GLOBAL-CHAIR GLOBAL-RUG)>

<OBJECT LR-FIREPLACE
	(IN LIVING-ROOM)
	(DESC "marble fireplace")
	(SYNONYM FIREPLACE FIRE CHIMNEY)
	(ADJECTIVE FORMAL ORNATE MARBLE)
	(ACTION LR-FIREPLACE-F)
	(CAPACITY 500)
	(FLAGS NDESCBIT CONTBIT OPENBIT SEARCHBIT)>

<ROUTINE LR-FIREPLACE-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE BURN>
		<COND (<NOT <FIRST? ,LR-FIREPLACE>> 
		       <TELL
"This fireplace has no fire burning in it." CR>)>)
	       (<VERB? THROUGH>
		<TELL
"This is Halloween, not Christmas." CR>)>>

<OBJECT PORTRAITS
	(IN LIVING-ROOM)
	(DESC "portrait")
	(SYNONYM PORTRAIT PICTURE FACES)
	(ADJECTIVE STERN ASHCROFT)
	(ACTION PORTRAIT-F)
	(FLAGS NDESCBIT)>

<ROUTINE PORTRAIT-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"There are many generations of Ashcrofts represented here. The family
settled in Maryland during the 1600s, and has been here ever since.
They've all had their portraits painted at one time or another." CR>)>>

<OBJECT MANTEL
	(IN LIVING-ROOM)
	(DESC "mantel")
	(SYNONYM MANTEL)
	(ADJECTIVE FORMAL ORNATE)
	(CAPACITY 50)
	(FLAGS NDESCBIT CONTBIT OPENBIT SEARCHBIT SURFACEBIT)>

<OBJECT GLOBAL-RUG
	(IN LOCAL-GLOBALS)
	(DESC "oriental rug")
	(SYNONYM RUG)
	(ADJECTIVE ORIENTAL)
	(ACTION RUG-F)
	(FLAGS NDESCBIT AN)>

<ROUTINE RUG-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This is an old and valuable " 'PRSO>
		<COND (<EQUAL? ,PRSO ,PSEUDO-OBJECT>
		       <TELL
", now horribly stained by copier toner">)>
		<TELL "." CR>)
	       (<VERB? LOOK-UNDER MOVE>
		<TELL
"Under the rug you see a wooden trap door... No, sorry! That's another
story." CR>)>>

<ROOM WEST-BATH
      (IN ROOMS)
      (SYNONYM BATH)
      (ADJECTIVE WEST)
      (DESC "West Bath")
      (LDESC
"This is a full bath, including a shower stall.")
      (SOUTH TO HALLWAY-2)
      (STATION HALLWAY-2)
      (GLOBAL WATER SINK SHOWER TOILET WEST-BATH-DOOR)
      (LINE 0 ;HALL-LINE-C)>

<ROOM LINEN-CLOSET
      (IN ROOMS)
      (SYNONYM CLOSET)
      (ADJECTIVE LINEN)
      (DESC "Linen Closet")
      (LDESC
"This is a small linen closet. It looks like most of the towels and
other supplies for the downstairs baths are kept here.")
      (NORTH TO HALLWAY-2 IF LINEN-CLOSET-DOOR IS OPEN)
      (GLOBAL LINEN-CLOSET-DOOR)
      (STATION HALLWAY-2)
      (LINE 0 ;HALL-LINE-C)
      (PSEUDO "TOWELS" TOWELS-PSEUDO "SUPPLI" TOWELS-PSEUDO)>

<ROUTINE TOWELS-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL "They are fluffy and soft." CR>)
	       (<VERB? TAKE>
		<TELL
"You have no need of that." CR>)>>

<ROOM EAST-BATH
      (IN ROOMS)
      (SYNONYM BATH BATHROOM)
      (ADJECTIVE EAST)
      (DESC "East Bath")
      (LDESC
"This is a normal half-bath, no shower or tub.")
      (NORTH TO HALLWAY-17 IF EAST-BATH-DOOR IS OPEN)
      (STATION HALLWAY-17)
      (GLOBAL WATER SINK TOILET EAST-BATH-DOOR)
      (LINE 2 ;EAST-HALL-LINE-C)>

<ROOM LIBRARY
      (IN ROOMS)
      (SYNONYM LIBRARY)
      (DESC "Library")
      (LDESC
"Every inch of wall space here is covered with bookshelves, except for
doors leading north and west, and two thickly curtained windows. There
are an enormous number of books here.")
      (NORTH TO HALLWAY-16 IF LIBRARY-DOOR IS OPEN)
      (WEST TO HALL IF LH-DOOR IS OPEN)
      (ACTION LIBRARY-F)
      (STATION HALLWAY-16)
      (LINE 2 ;EAST-HALL-LINE-C)
      (GLOBAL WINDOW CURTAINS LH-DOOR TELEPHONE LIBRARY-DOOR)
      (PSEUDO "BOOKS" BOOKS-PSEUDO)>

<ROUTINE JUMPED-OUT? (RM)
	 <COND (<AND ,PLAYER-HIDING
		     <EQUAL? ,HERE .RM>
		     <VERB? WALK TELL ASK-ABOUT
			    $CALL STAND TAKE HELLO
			    OPEN PHONE>>
		<RTRUE>)>>

<ROUTINE LIBRARY-F (RARG)
	 <COND (<==? .RARG ,M-BEG>
		<COND (<AND <OR <IN? ,MICHAEL ,LIBRARY>
				<IN? ,COL-MARSTON ,LIBRARY>>
			    <JUMPED-OUT? ,LIBRARY>>
		       <SETG PLAYER-HIDING <>>
		       <TELL
"As you emerge from concealment, ">
		       <COND (<AND <IN? ,MICHAEL ,LIBRARY>
				   <IN? ,COL-MARSTON ,LIBRARY>>
			      <TELL
'MICHAEL " and " 'COL-MARSTON " stare at you and then at each other">
			      <COND (<IN? ,INVESTOR-LIST ,MICHAEL>
				     <TELL
", shocked expressions on their faces">)>
			      <TELL "." CR>)
			     (ELSE
			      <COND (<IN? ,MICHAEL ,LIBRARY>
				     <TELL 'MICHAEL>)
				    (T
				     <TELL 'COL-MARSTON>)>
			      <TELL " stares at you, surprised." CR>)>
		       <MURDER-TELL ,PLAYER
				    <COND (<IN? ,MICHAEL ,LIBRARY>
					   ,MICHAEL)
					  (T ,COL-MARSTON)>>
		       <RTRUE>)>)>>

<OBJECT BOOKCASES
	(IN LIBRARY)
	(DESC "bookcase")
	(SYNONYM BOOKCASE SHELVES SHELF)
	(ACTION BOOKCASES-F)
	(FLAGS NDESCBIT OPENBIT CONTBIT)
	(CAPACITY 50)>

<ROUTINE BOOKCASES-F ()
	 <COND (<VERB? LOOK-INSIDE EXAMINE>
		<TELL
"The bookcases contain many books." CR>)>>

<OBJECT LIBRARY-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "north library door")
	(SYNONYM DOOR)
	(ADJECTIVE LIBRARY NORTH)
	(UNLOCK LIBRARY)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<GLOBAL RIDICULOUS "You would look ridiculous carrying it.">

<ROUTINE TELL-GET-UP ()
	 <TELL ,HAVE-TO "get up first." CR>>

<OBJECT SIDE-TABLE
	(IN LIBRARY)
	(DESC "side table")
	(LDESC
"On the right side of the chair is a small side table with a telephone on
it.")
	(SYNONYM TABLE)
	(ADJECTIVE SIDE)
	(ACTION VARIOUS-TABLES-F)
	(CAPACITY 20)
	(FLAGS FURNITURE VEHBIT TRYTAKEBIT TAKEBIT SURFACEBIT OPENBIT CONTBIT)>

<ROUTINE VARIOUS-TABLES-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <VERB? TAKE>
		     <EQUAL? ,PRSO ,SIDE-TABLE ,END-TABLE>>
		<TELL ,RIDICULOUS CR>)
	       (<VERB? EXAMINE>
		<TELL
"On " THE ,PRSO " sits " A ,TELEPHONE>
		<PRINT-CONTENTS ,PRSO ", accompanied by ">
		<TELL "." CR>)>>

<OBJECT CHAIR
	(IN LIBRARY)
	(DESC "comfy chair")
	(LDESC
"In one corner of the room is a high-backed, overstuffed Victorian armchair,
which looks perfect for reading in.")
	(SYNONYM CHAIR ARMCHAIR)
	(ADJECTIVE HIGH OVERSTUFFED ARM VICTORIAN)
	(FLAGS FURNITURE VEHBIT TRYTAKEBIT TAKEBIT OPENBIT CONTBIT)
	(SIZE 100)
	(CAPACITY 100)
	(ACTION CHAIR-F)>

<ROUTINE CHAIR-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-BEG ,M-END>
		<RFALSE>)
	       (<AND <VERB? TAKE> <EQUAL? ,PRSO ,CHAIR>>
		<TELL ,RIDICULOUS CR>)
	       (<AND <VERB? HIDE-BEHIND> <NOT ,PLAYER-HIDING>>
		<COND (<IN? ,PLAYER ,CHAIR>
		       <TELL-GET-UP>)
		      (T
		       <NOW-CONCEALED>)>)
	       (<VERB? RUB>
		<TELL
"It feels very soft and comfy." CR>)>>

<OBJECT DEATHMASK-BOOK
	(IN SIDE-TABLE)
	(DESC "paperback book")
	(SYNONYM BOOK)
	(ADJECTIVE PAPERBACK)
	(FLAGS READBIT TAKEBIT BURNBIT)
	(ACTION DEATHMASK-BOOK-F)
	(TEXT
"The book has a lurid cover and an obviously inaccurate blurb. It is
titled \"Suspect,\" and is by someone named Dave Lebling. The book
is apparently a mystery novel. You read part of it, but stop
when you notice that someone has torn out the last ten pages.")>

<ROUTINE DEATHMASK-BOOK-F ()
	 <COND (<VERB? EXAMINE OPEN>
		<PERFORM ,V?READ ,PRSO>
		<RTRUE>)>>

<ROUTINE BOOKS-PSEUDO ()
	 <COND (<VERB? READ>
		<TELL 
"That would take many months, even assuming you are a star pupil of Evelyn
Wood." CR>)
	       (<VERB? EXAMINE>
		<TELL
"A great many of the books have to do with horses, horse breeding, farm
management, and other practical subjects.">
		<COND (<EQUAL? ,HERE ,LIBRARY>
		       <TELL " There is a lot of fiction as
well, including the complete works of Dick Francis.">)>
		<CRLF>)>>

<ROOM SUN-ROOM
      (IN ROOMS)
      (SYNONYM ROOM)
      (ADJECTIVE SUN)
      (DESC "Sun Room")
      (LDESC
"This room is situated to receive the morning sun, and in daytime
would be bright and airy. Many plants crowd the floor,
fill the plant stands situated under the windows, and hang from hooks
attached to the ceiling. Ms. Ashcroft has a green thumb, apparently.")
      (NORTH TO HALLWAY-19 IF SUN-ROOM-DOOR IS OPEN)
      (GLOBAL WINDOW CURTAINS SUN-ROOM-DOOR)
      (STATION HALLWAY-19)
      (LINE 2 ;EAST-HALL-LINE-C)>

<OBJECT PLANTS
	(IN SUN-ROOM)
	(DESC "plant")
	(SYNONYM PLANTS PLANT POTS POT)
	(FLAGS NDESCBIT TRYTAKEBIT TAKEBIT)
	(ACTION PLANTS-F)>

<ROUTINE PLANTS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"There are plants all over the room." ,DOING-WELL CR>)
	       (<VERB? TAKE>
		<TELL-CARE>)>>

<ROUTINE TELL-CARE ()
	 <TELL
"After all the care that's been lavished on them? For shame." CR>>

<GLOBAL DOING-WELL " They are doing quite well.">

<ROOM DINING-ROOM
      (IN ROOMS)
      (SYNONYM ROOM)
      (ADJECTIVE DINING)
      (DESC "Dining Room")
      (LDESC
"This is the formal dining room. To the south is the long hall, to the
east the kitchen. A crystal chandelier dominates the room, hanging over
a large walnut table. On the east wall convenient to the kitchen is a
long sideboard. On the north wall is a china cabinet. The west wall is
mostly windows which overlook the garden.")
      (SOUTH TO HALLWAY-15)
      (EAST TO KITCHEN)
      (LINE 0 ;HALL-LINE-C)
      (STATION DINING-ROOM)
      (GLOBAL WINDOW CURTAINS GLOBAL-CHAIR)
      (PSEUDO "CHINA" CHINA-PSEUDO "CRYSTAL" CHINA-PSEUDO)>

<ROUTINE CHINA-PSEUDO ()
	 <COND (<VERB? EXAMINE> <TELL "It's lovely." CR>)
	       (<VERB? TAKE> <TELL "It's in a locked cabinet." CR>)>>

<OBJECT CHANDELIER
	(IN DINING-ROOM)
	(SYNONYM CHANDELIER)
	(ADJECTIVE CRYSTAL)
	(DESC "chandelier")
	(ACTION CHANDELIER-F)
	(FLAGS NDESCBIT)>

<ROUTINE CHANDELIER-F ()
	 <COND (<VERB? TAKE>
		<TELL "It's too high to reach." CR>)>>

<OBJECT DINING-ROOM-TABLE
	(IN DINING-ROOM)
	(SYNONYM TABLE)
	(ADJECTIVE WALNUT)
	(DESC "table")
	(CAPACITY 100)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)>

<OBJECT SIDEBOARD
	(IN DINING-ROOM)
	(SYNONYM BOARD)
	(ADJECTIVE SIDE)
	(DESC "sideboard")
	(CAPACITY 100)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT)>

<OBJECT CHINA-CABINET
	(IN DINING-ROOM)
	(SYNONYM CABINET)
	(ADJECTIVE CHINA CRYSTAL)
	(DESC "china cabinet")
	(CAPACITY 100)
	(ACTION CHINA-CABINET-F)
	(FLAGS NDESCBIT LOCKED TRANSBIT CONTBIT)>

<ROUTINE CHINA-CABINET-F ()
	 <COND (<VERB? LOOK-INSIDE EXAMINE>
		<TELL
,THERE-IS "an exquisite set of antique china and crystal inside "
THE ,CHINA-CABINET "." CR>)>>

<ROOM KITCHEN
      (IN ROOMS)
      (SYNONYM KITCHEN)
      (DESC "Kitchen")
      (LDESC
"This is a large country kitchen. It is quite disarrayed right now
because of the party. There are doorways leading south to the ballroom,
west to the dining room, and north to the back entry. There is a stove
with a kettle boiling on top of it, and telephone over a counter on one
wall.")
      (NORTH TO BACK-ENTRY)
      (SOUTH TO BALLROOM-3)
      (WEST TO DINING-ROOM)
      (LINE 0 ;HALL-LINE-C)
      (STATION KITCHEN)
      (GLOBAL WATER WINDOW CURTAINS SINK TELEPHONE FOOD)
      (PSEUDO "STOVE" STOVE-PSEUDO "KETTLE" KETTLE-PSEUDO)>

<ROUTINE STOVE-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This is a gas stove with a kettle boiling on one burner." CR>)
	       (<VERB? LAMP-ON>
		<TELL ,ITS-ALREADY "on." CR>)
	       (<VERB? LAMP-OFF>
		<TELL "But then the fish won't get done!" CR>)>>

<ROUTINE KETTLE-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This is a fine kettle of fish." CR>)
	       (<VERB? TAKE>
		<TELL
"It's much too hot to take." CR>)>>

<ROOM BACK-ENTRY
      (IN ROOMS)
      (SYNONYM ENTRY)
      (ADJECTIVE BACK)
      (DESC "Back Entry")
      (LDESC
"This is the back entry to the kitchen. A door leads outside to the north.")
      (NORTH TO BACK-PORCH IF BACK-DOOR IS OPEN)
      (SOUTH TO KITCHEN)
      (LINE 0 ;HALL-LINE-C)
      (STATION BACK-ENTRY)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW STAIR BACK-DOOR)>

<OBJECT BACK-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "back door")
	(SYNONYM DOOR)
	(ADJECTIVE BACK)
	(UNLOCK BACK-ENTRY)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS LOCKED DOORBIT NDESCBIT)>

<ROOM BACK-PORCH
      (IN ROOMS)
      (SYNONYM PORCH)
      (ADJECTIVE BACK)
      (DESC "Back Porch")
      (LDESC
"This is the back porch. The kitchen is to the south, and a flagstone path
leads east and west.")
      (IN TO BACK-ENTRY IF BACK-DOOR IS OPEN)
      (SOUTH TO BACK-ENTRY IF BACK-DOOR IS OPEN)
      (WEST TO GARDEN)
      (SW TO GARDEN)
      (EAST TO PATIO)
      (DOWN TO PATIO)
      (LINE 4 ;OUTSIDE-LINE-C)
      (STATION BACK-PORCH)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW BACK-DOOR)>

<ROOM GARAGE
      (IN ROOMS)
      (SYNONYM GARAGE)
      (DESC "Garage")
      (LDESC
"The garage holds four cars quite comfortably, each with its own
separate door. After parking, one can leave through the door to the
east, which leads to a covered walkway and the main house. At the
house end of the garage is an immaculate workbench.")
      (EAST TO WALKWAY IF WALKWAY-DOOR IS OPEN)
      (WEST "The garage doors are closed and locked.")
      (ACTION GARAGE-F)
      (GLOBAL WALKWAY-DOOR GARAGE-DOOR)
      (LINE 3 ;GARAGE-LINE-C)
      (STATION GARAGE)>

<ROUTINE GARAGE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <IN? ,MICHAEL ,GARAGE>
			    <JUMPED-OUT? ,GARAGE>>
		       <PLAYER-EMERGES>
		       <SETG PLAYER-HIDING <>>
		       <TELL 'MICHAEL " jumps in surprise.">
		       <COND (<NOT <FSET? ,PLAYER ,TOLD>>
			      <TELL " ">
			      <MURDER-TELL ,PLAYER ,MICHAEL>)
			     (ELSE <CRLF>)>)>)>>

<OBJECT WORKBENCH
	(IN GARAGE)
	(DESC "workbench")
	(SYNONYM WORKBENCH BENCH)
	(ADJECTIVE WORK)
	(CAPACITY 100)
	(FLAGS NDESCBIT SURFACEBIT CONTBIT OPENBIT)>

<OBJECT MERCEDES
	(IN GARAGE)
	(DESC "Mercedes 280SL")
	(SYNONYM CAR MERCEDES 280SL)
	(ADJECTIVE MERCEDES)
	(ACTION CAR-F)
	(FLAGS VEHBIT LOCKED CONTBIT DOORBIT TRANSBIT WINDOWBIT)>

<OBJECT BMW
	(IN GARAGE)
	(DESC "BMW 320i")
	(SYNONYM CAR BMW 320I)
	(ADJECTIVE BMW)
	(ACTION CAR-F)
	(FLAGS VEHBIT LOCKED CONTBIT DOORBIT TRANSBIT WINDOWBIT)>

<ROUTINE TELL-LOCKED ()
	 <TELL CTHE ,PRSO " is securely locked." CR>>

<ROUTINE CAR-F ("OPTIONAL" (RARG <>))
	 <COND (<VERB? THROUGH OPEN UNLOCK>
		<TELL-LOCKED>)
	       (<VERB? LOOK-INSIDE>
		<TELL
"The windows are tinted, but you can see inside well enough to
tell there is nothing there." CR>)
	       (<VERB? EXAMINE>
		<TELL
"The car is a late-model " D ,PRSO ". It has Maryland plates." CR>)
	       (<AND <VERB? HIDE-BEHIND> <NOT ,PLAYER-HIDING>>
		<SETG PLAYER-HIDING ,PRSO>
		<TELL
,YOU-ARE "now hiding behind the car. It's dim here and you are
well concealed." CR>)>>

<OBJECT BMW-TRUNK
	(IN BMW)
	(DESC "BMW's trunk")
	(SYNONYM TRUNK)
	(ADJECTIVE BMW BMW\'S)
	(ACTION TRUNK-F)
	(FLAGS LOCKED CONTBIT SEARCHBIT NDESCBIT)
	(CAPACITY 100)>

<OBJECT MERCEDES-TRUNK
	(IN MERCEDES)
	(DESC "Mercedes' trunk")
	(SYNONYM TRUNK)
	(ADJECTIVE MERCEDES)
	(ACTION TRUNK-F)
	(FLAGS LOCKED CONTBIT SEARCHBIT NDESCBIT)
	(CAPACITY 100)>

<ROUTINE TRUNK-F ()
	 <COND (<VERB? OPEN UNLOCK>
		<COND (<FSET? ,PRSO ,LOCKED>
		       <TELL-LOCKED>)>)>>

<OBJECT TOOL-CHEST
	(IN GARAGE)
	(DESC "tool chest")
	(FDESC "In front of the workbench is a battered tool chest.") 
	(SYNONYM TOOLCHEST CHEST)
	(ADJECTIVE BATTERED TOOL)
	(CAPACITY 30)
	(FLAGS TAKEBIT CONTBIT)>

<OBJECT CROWBAR
	(IN TOOL-CHEST)
	(DESC "crowbar")
	(SYNONYM CROWBAR)
	(ACTION CROWBAR-F)
	(FLAGS TAKEBIT TOOLBIT)>

<ROUTINE CROWBAR-F ()
	 <COND (<AND <VERB? UNLOCK> <EQUAL? ,PRSI ,CROWBAR>>
		<TELL
"A crowbar doesn't unlock things, it pries them open." CR>)
	       (<VERB? OPEN MUNG PICK>
		<COND (<EQUAL? ,PRSO ,BMW ,MERCEDES ,POLICE-CAR>
		       <TELL
"Turning to car theft since you can't make it in journalism?" CR>)
		      (<EQUAL? ,PRSO ,BMW-TRUNK ,MERCEDES-TRUNK>
		       <COND (<IN? ,MICHAEL ,HERE>
			      <TELL
"Michael stops you. \"Just what do you think you're doing?\"" CR>)
			     (<FSET? ,PRSO ,OPENBIT>
			      <TELL
"The trunk is already open." CR>)
			     (ELSE
			      <FCLEAR ,PRSO ,LOCKED>
			      <FSET ,PRSO ,OPENBIT>
			      <TELL
"The trunk lid pops open">
			      <COND (<FIRST? ,PRSO>
				     <TELL
", revealing ">
				     <PRINT-CONTENTS ,PRSO>)>
			      <TELL "." CR>)>)
		      (<OR <FSET? ,PRSO ,DOORBIT>
			   <FSET? ,PRSO ,WINDOWBIT>>
		       <COND (<FSET? ,BURGLAR-ALARM ,ONBIT>
			      <TELL
"Trying for another B&E, eh?" CR>)
			     (T
			      <FSET ,BURGLAR-ALARM ,ONBIT>
			      <ENABLE <QUEUE I-BURGLAR-ALARM -1>>
			      <TELL
"Your clumsy attempt to " <COND (<VERB? OPEN> "force open")
				(ELSE "smash")> " the " D ,PRSO
" has set off " THE ,BURGLAR-ALARM "." CR>)>)>)>>

<OBJECT BURGLAR-ALARM
	(IN GLOBAL-OBJECTS)
	(SYNONYM ALARM)
	(ADJECTIVE BURGLAR)
	(DESC "burglar alarm")
	(ACTION BURGLAR-ALARM-F)
	(FLAGS NDESCBIT)>

<ROUTINE BURGLAR-ALARM-F ()
	 <COND (<VERB? LAMP-OFF>
		<TELL CTHE ,BURGLAR-ALARM " switch" ,ISNT-HERE CR>)
	       (<AND <VERB? LISTEN> <FSET? ,BURGLAR-ALARM ,ONBIT>>
		<TELL "I take it you are deaf?" CR>)>>

<GLOBAL ALARM-COUNT 0>

<ROUTINE I-BURGLAR-ALARM ()
	 <COND (<FSET? ,BURGLAR-ALARM ,ONBIT>
		<COND (<G? <SETG ALARM-COUNT <+ ,ALARM-COUNT 1>> 30>
		       <SETG ALARM-COUNT 0>
		       <FCLEAR ,BURGLAR-ALARM ,ONBIT>
		       <DISABLE <INT I-BURGLAR-ALARM>>)
		      (ELSE
		       <TELL CTHE ,BURGLAR-ALARM " rings stridently." CR>)>)>
	 <RFALSE>>

\

"Ballroom Area"

<OBJECT GLOBAL-BALLROOM
	(IN GLOBAL-OBJECTS)
	(SYNONYM BALLROOM)
	(DESC "Ballroom")
	(ACTION GLOBAL-BALLROOM-F)>

<ROUTINE GLOBAL-BALLROOM-F ()
	 <COND (<VERB? WALK-TO>
		<COND (<IN-BALLROOM? ,HERE>
		       <TELL-ALREADY-ARE>)
		      (ELSE
		       <PERFORM ,V?WALK-TO ,BALLROOM-5>
		       <RTRUE>)>)>>

<ROOM BALLROOM-1
      (IN ROOMS)
      (SYNONYM ENTRANCE)
      (ADJECTIVE NORTH)
      (DESC "North Entrance")
      (FDESC "near the north entrance")
      (LDESC
"This is the northern end of the ballroom, near the entrance.")
      (WEST TO HALLWAY-14)
      (SOUTH TO BALLROOM-4)
      (EAST TO BALLROOM-2)
      (IN TO BALLROOM-5)
      (SE TO BALLROOM-5)
      (ACTION BALLROOM-F)
      (GLOBAL FOOD)
      (STATION BALLROOM-4)
      (LINE 1 ;BALLROOM-LINE-C)
      (CORRIDOR 32)>

<ROOM BALLROOM-2
      (IN ROOMS)
      (DESC "Near Band")
      (FDESC "near the band")
      (LDESC
"This is the northern end of the ballroom. A raised area provides a
band platform, and there is a stereo hookup for use when there is
no band.")
      (SOUTH TO BALLROOM-5)
      (IN TO BALLROOM-5)
      (EAST TO BALLROOM-3)
      (WEST TO BALLROOM-1)
      (SW TO BALLROOM-4)
      (SE TO BALLROOM-6)
      (ACTION BALLROOM-F)
      (GLOBAL FOOD)
      (STATION BALLROOM-2)
      (LINE 1 ;BALLROOM-LINE-C)>

<ROOM BALLROOM-3
      (IN ROOMS)
      (DESC "Near Kitchen")
      (FDESC "near the kitchen door")
      (LDESC
"The northern end of the ballroom, next to the door leading to the
kitchen. To the west is a band platform.")
      (NORTH TO KITCHEN)
      (SOUTH TO BALLROOM-6)
      (WEST TO BALLROOM-2)
      (IN TO BALLROOM-5)
      (SW TO BALLROOM-5)
      (ACTION BALLROOM-F)
      (LINE 1 ;BALLROOM-LINE-C)
      (STATION BALLROOM-3)
      (GLOBAL WINDOW FOOD)>

<ROOM BALLROOM-4
      (IN ROOMS)
      (SYNONYM ENTRANCE)
      (ADJECTIVE CENTER)
      (DESC "Center Entrance")
      (FDESC "near the center entrance")
      (LDESC
"This is the middle area of the ballroom, near the center entrance.")
      (NORTH TO BALLROOM-1)
      (SOUTH TO BALLROOM-7)
      (EAST TO BALLROOM-5)
      (IN TO BALLROOM-5)
      (WEST TO HALLWAY-13)
      (NE TO BALLROOM-2)
      (SE TO BALLROOM-8)
      (ACTION BALLROOM-F)
      (GLOBAL FOOD)
      (LINE 1 ;BALLROOM-LINE-C)
      (STATION BALLROOM-4)
      (CORRIDOR 64)>

<ROOM BALLROOM-5
      (IN ROOMS)
      (SYNONYM FLOOR)
      (ADJECTIVE DANCE)
      (DESC "Dance Floor")
      (FDESC "on the dance floor")
      (LDESC
"This is the dance floor, smack in the center of the ballroom.")
      (NORTH TO BALLROOM-2)
      (SOUTH TO BALLROOM-8)
      (EAST TO BALLROOM-6)
      (WEST TO BALLROOM-4)
      (SE TO BALLROOM-9)
      (SW TO BALLROOM-7)
      (NE TO BALLROOM-3)
      (NW TO BALLROOM-1)
      (ACTION BALLROOM-5-F)
      (LINE 1 ;BALLROOM-LINE-C)
      (STATION BALLROOM-5)>

<GLOBAL ON-DANCE-FLOOR? <>>

<ROUTINE BALLROOM-5-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<BALLROOM-F .RARG>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     <L? ,OVER-COUNT 3>>
		<SETG ON-DANCE-FLOOR? T>
		<RFALSE>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <VERB? WALK FOLLOW> ,ON-DANCE-FLOOR?>
		       <SETG ON-DANCE-FLOOR? <>>
		       <TELL
"There are quite a few dancers on the floor, and it takes time to pick
your way among them. You eventually make some progress, though." CR>)
		      (<AND <VERB? ASK-FOR>
			    <IN? ,PRSO ,HERE>
			    <EQUAL? ,PRSI ,BALLROOM-5>>
		       <PERFORM ,V?DANCE ,PRSO>
		       <RTRUE>)
		      (<AND <VERB? PUT>
			    <EQUAL? ,PRSI ,BALLROOM-5>>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)>)>>

<ROOM BALLROOM-6
      (IN ROOMS)
      (DESC "Near French Door")
      (FDESC "near the French door leading to the patio")
      (LDESC
"This is near the middle of the ballroom, at a French door leading out
to the patio.")
      (NORTH TO BALLROOM-3)
      (SOUTH TO BALLROOM-9)
      (EAST TO PATIO IF FRENCH-DOOR IS OPEN)
      (WEST TO BALLROOM-5)
      (IN TO BALLROOM-5)
      (NW TO BALLROOM-2)
      (SW TO BALLROOM-8)
      (ACTION BALLROOM-F)
      (LINE 1 ;BALLROOM-LINE-C)
      (STATION BALLROOM-6)
      (CORRIDOR 256)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW FRENCH-DOOR FOOD)>

<ROOM BALLROOM-7
      (IN ROOMS)
      (SYNONYM ENTRANCE)
      (ADJECTIVE SOUTH)
      (DESC "South Entrance")
      (FDESC "near the south entrance")
      (LDESC
"This is near the south entrance to the ballroom. The fireplace is to
the east, and the long hall is visible outside the entrance.")
      (NORTH TO BALLROOM-4)
      (SE TO BALLROOM-8)
      (EAST TO BALLROOM-8)
      (WEST TO HALLWAY-12)
      (IN TO BALLROOM-5)
      (NE TO BALLROOM-5)
      (ACTION BALLROOM-F)
      (GLOBAL FOOD)
      (LINE 1 ;BALLROOM-LINE-C)
      (STATION BALLROOM-7)
      (CORRIDOR 128)>

<ROOM BALLROOM-8
      (IN ROOMS)
      (DESC "Near Fireplace")
      (FDESC "near the fireplace")
      (LDESC
"This is the south end of the ballroom. A huge fieldstone fireplace
dominates the south wall. The bar is to the east.")
      (NORTH TO BALLROOM-5)
      (IN TO BALLROOM-5)
      (EAST TO BALLROOM-9)
      (WEST TO BALLROOM-7)
      (NW TO BALLROOM-4)
      (NE TO BALLROOM-6)
      (STATION BALLROOM-8)
      (LINE 1 ;BALLROOM-LINE-C)
      (ACTION BALLROOM-8-F)
      (GLOBAL FOOD)>

<OBJECT BAR
	(IN BALLROOM-9)
	(DESC "bar")
	(SYNONYM BAR)
	(ACTION BAR-F)
	(FLAGS NDESCBIT)>

<ROUTINE BAR-F ()
	 <COND (<VERB? WALK-TO>
		<COND (<EQUAL? ,HERE ,BALLROOM-9>
		       <TELL
"Jack Johnson, the bartender, greets you. He looks at you quizzically,
no doubt expecting you to order a drink." CR>)
		      (ELSE
		       <PERFORM ,V?WALK-TO ,BALLROOM-9>
		       <RTRUE>)>)>>

<OBJECT LOCAL-BAND
	(IN BALLROOM-2)
	(DESC "band")
	(SYNONYM BAND)
	(ACTION LOCAL-BAND-F)
	(DESCFCN LOCAL-BAND-DESC-F)
	(FLAGS PERSON THE)>

<ROUTINE LOCAL-BAND-DESC-F ("OPTIONAL" (RARG <>))
	 <COND (<IN? ,LOCAL-BAND ,KITCHEN>
		<TELL
"The band members are on their break. They are sitting around joking,
drinking coffee, and wolfing down sandwiches and shrimp cocktail." CR>)
	       (ELSE
		<TELL
"The band is here, playing their set." CR>)>>

<ROUTINE LOCAL-BAND-F ()
	 <COND (<EQUAL? ,LOCAL-BAND ,WINNER>
		<TELL "The band is busy ">
		<COND (<IN? ,LOCAL-BAND ,KITCHEN>
		       <TELL "resting and eating">)
		      (ELSE <TELL "performing">)>
		<TELL ", and has no time to talk." CR>)
	       (<AND <VERB? SHOW> <EQUAL? ,PRSI ,LOCAL-BAND>>
		<TELL "These guys are pretty cool, and react accordingly." CR>)
	       (<VERB? SMELL>
		<TELL "The band stinks." CR>)
	       (<TALKING-TO? ,LOCAL-BAND>
		<TELL "The band is too busy "
		      <COND (<IN? ,LOCAL-BAND ,KITCHEN> "eating")
			    (T "playing")> " to respond." CR>)
	       (<VERB? EXAMINE>
		<COND (<G? ,PRESENT-TIME 764>
		       <TELL "What band?" CR>
		       <RTRUE>)>
		<TELL
"The band consists of five guys in checked sport coats. They are very
professional, but their repertoire is basically middle-of-the-road,
either because they like it that way or because they were asked
to play that sort of thing." CR>)
	       (<VERB? FIND FOLLOW>
		<COND (<G? ,PRESENT-TIME 764>
		       <TELL "What band? They've gone home." CR>)
		      (<EQUAL? ,HERE <LOC ,LOCAL-BAND>>
		       <TELL "They're right">
		       <TELL-HERE>)
		      (ELSE
		       <TELL
"They're either in the ballroom or the kitchen." CR>)>)
	       (<VERB? WALK-TO>
		<COND (<G? ,PRESENT-TIME 764>
		       <TELL "What band? They've gone home." CR>)
		      (<EQUAL? ,HERE <LOC ,LOCAL-BAND>>
		       <TELL-CLOSE-ENOUGH>)
		      (ELSE
		       <PERFORM ,V?WALK-TO <LOC ,LOCAL-BAND>>
		       <RTRUE>)>)
	       (<VERB? LISTEN>
		<COND (,BAND-PLAYING?
		       <TELL
"The band is playing \"" ,BAND-PLAYING? ".\"" CR>)
		      (<G? ,PRESENT-TIME 764>
		       <TELL
"The band has gone home." CR>)
		      (ELSE
		       <TELL
"The band is on its break." CR>)>)>>

<OBJECT RECORD-PLAYER
	(IN BALLROOM-2)
	(DESC "record player")
	(SYNONYM PLAYER)
	(ADJECTIVE RECORD)
	(ACTION RECORD-PLAYER-F)
	(FLAGS NDESCBIT)>

<ROUTINE RECORD-PLAYER-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This is a state-of-the-art stereo system, not really " A ,RECORD-PLAYER ".
It is actually installed in the wall behind the band. It looks very
high-tech and glitzy." CR>)
	       (<VERB? WALK-TO>
		<COND (<EQUAL? ,HERE ,BALLROOM-2>
		       <TELL-CLOSE-ENOUGH>)
		      (ELSE
		       <PERFORM ,V?WALK-TO ,BALLROOM-2>
		       <RTRUE>)>)
	       (<VERB? LISTEN>
		<TELL CTHE ,RECORD-PLAYER " is">
		<COND (,RECORD-PLAYING?
		       <TELL
" playing \"" ,RECORD-PLAYING? ".\"" CR>)
		      (,PARTY-OVER
		       <TELL
" turned off." CR>)
		      (ELSE
		       <TELL
"n't playing anything." CR>)>)>>

<OBJECT MUSIC
	(IN GLOBAL-OBJECTS)
	(DESC "music")
	(SYNONYM MUSIC)
	(ACTION MUSIC-F)
	(FLAGS NDESCBIT)>

<ROUTINE MUSIC-F ()
	 <COND (<VERB? LISTEN>
		<COND (<IN-BALLROOM? ,PLAYER>
		       <COND (,BAND-PLAYING?
			      <PERFORM ,V?LISTEN ,LOCAL-BAND>)
			     (,RECORD-PLAYING?
			      <PERFORM ,V?LISTEN ,RECORD-PLAYER>)
			     (ELSE <TELL "You hear no music." CR>)>
		       <RTRUE>)
		      (ELSE
		       <TELL-YOU-CANT "hear any music">)>)>>

<OBJECT FIREPLACE
	(IN BALLROOM-8)
	(DESC "fieldstone fireplace")
	(SYNONYM FIREPLACE FIRE CHIMNEY)
	(ADJECTIVE LARGE FIELDSTONE)
	(ACTION FIREPLACE-F)
	(DESCFCN FIREPLACE-F)
	(CONTFCN FIREPLACE-F)
	(CAPACITY 500)
	(FLAGS CONTBIT OPENBIT SEARCHBIT)>

<ROUTINE FIREPLACE-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-OBJDESC>
		<COND (<FIRST? ,FIREPLACE>
		       <TELL
,THERE-IS "something other than logs burning in the fireplace." CR>)>
		<RTRUE>)>
	 <COND (<AND <VERB? TAKE>
		     <NOT <EQUAL? ,PRSO ,FIREPLACE ,INVESTOR-LIST>>>
		<COND (<FSET? ,PRSO ,BURNBIT>
		       <TELL
"You try, but it's aflame and you almost burn yourself." CR>)
		      (T
		       <TELL
"It's too hot from the fire." CR>)>)
	       (<AND <VERB? POUR-ON>
		     <EQUAL? ,PRSO ,DRINK>
		     <EQUAL? ,PRSI ,FIREPLACE>>
		<TELL "Some of " THE ,DRINK " sizzles away to vapor." CR>)
	       (<AND <VERB? PUT BURN DROP>
		     <EQUAL? ,PRSI ,FIREPLACE>>
		<COND (<EQUAL? ,PRSO ,ME ,PLAYER>
		       <PERFORM ,V?KILL ,PLAYER>
		       <RTRUE>)
		      (<EQUAL? ,PRSO ,CORPSE ,FAIRY-COSTUME>
		       <TELL
"You stop short, realizing that it would look very bad and ensure your
conviction for the murder." CR>
		       <RTRUE>)>
		<FCLEAR ,PRSO ,WEARBIT>
		<MOVE ,PRSO ,FIREPLACE>
		<ENABLE <QUEUE I-BURN-OBJ 2>>
		<TELL
CTHE ,PRSO " goes into the fire">
		<COND (<FSET? ,PRSO ,BURNBIT>
		       <TELL ", where it begins to burn">)>
		<TELL "." CR>)
	       (<VERB? LAMP-OFF>
		<TELL-YOU-CANT "put out the fire">)
	       (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<PRINT-CONTENTS ,FIREPLACE
"In the fireplace, endangered by the fire, you can see ">
		       <TELL "." CR>)
		      (ELSE
		       <TELL
,THERE-IS "a cheery and warm fire burning in the fireplace." CR>)>)
	       (<VERB? THROUGH>
		<TELL
"It's certainly chilly and damp tonight, but I don't think that's the best
way to do something about it." CR>)
	       (<VERB? WALK-TO>
		<COND (<EQUAL? ,HERE ,BALLROOM-8>
		       <TELL-CLOSE-ENOUGH>)
		      (ELSE
		       <PERFORM ,V?WALK-TO ,BALLROOM-8>
		       <RTRUE>)>)>>

<ROUTINE TELL-CLOSE-ENOUGH ()
	 <TELL ,YOU-ARE "close enough already." CR>>

<ROUTINE I-BURN-OBJ ("AUX" (F <FIRST? ,FIREPLACE>) (BURNED <>))
	 <REPEAT ()
		 <COND (<FSET? .F ,BURNBIT>
			<COND (.BURNED
			       <ENABLE <QUEUE I-BURN-OBJ 1>>)>
			<SET BURNED .F>)>
		 <COND (<NOT <SET F <NEXT? .F>>>
		        <RETURN>)>>
	 <COND (.BURNED
		<MOVE .BURNED ,POLICE-LAB>
		<COND (<EQUAL? ,HERE ,BALLROOM-8>
		       <TELL
CTHE .BURNED " has now been consumed by the fire." CR>)>)>>

<GLOBAL MICHAEL-GREETING? <>>

<ROUTINE BALLROOM-8-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<BALLROOM-F ,M-LOOK>)
	       (<==? .RARG ,M-END>
		<COND (<IN-MOTION? ,VERONICA>
		       <RFALSE>)
		      (<AND <NOT ,MICHAEL-GREETING?>
			    <IN? ,MICHAEL ,HERE>
			    <IN? ,VERONICA ,HERE>>
		       <SETG MICHAEL-GREETING? T>
		       <DISABLE <INT I-WAVE-2>>
		       <ENABLE <QUEUE I-SPILL 1>>
		       <VERONICA-UNMASKS>
		       <CRLF>
		       <TELL
"The sheik, " 'MICHAEL ", nods a greeting. \"The weather out there is horrible: glad
you could make it.\" He introduces you to the group around him. \"...and
you already know " 'VERONICA ".\" The fairy nods in your direction. \"You might
find this worth adding to your story,\" he suggests." CR>)>)>>

<ROOM BALLROOM-9
      (IN ROOMS)
      (DESC "Near Bar")
      (FDESC "at the bar")
      (LDESC
"This is the south end of the ballroom, at the bar.")
      (NORTH TO BALLROOM-6)
      (WEST TO BALLROOM-8)
      (NW TO BALLROOM-5)
      (IN TO BALLROOM-5)
      (ACTION BALLROOM-9-F)
      (STATION BALLROOM-9)
      (LINE 1 ;BALLROOM-LINE-C)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW FOOD)>

<ROUTINE BALLROOM-9-F ("OPTIONAL" (RARG <>))
	 <COND (<==? .RARG ,M-LOOK>
		<BALLROOM-F ,M-LOOK>)
	       (<AND <==? .RARG ,M-ENTER>
		     <G? ,ARGUMENT-COUNT 0>>
		<TELL
"You seem to have come in on the midst of " A ,DISCUSSION "." CR>)>>

<GLOBAL COSTUMES
	<LTABLE 0
		"a man in street clothes wearing a square white plastic mask"
		"a woman disguised as a peanut butter sandwich"
		"a man who looks like Cardinal Richelieu"
		"three people dressed as mice wearing dark glasses"
		"a Pac-man"
		"a giant spider"
		"a short, cuddly-looking robot"
		"a grue"
		"a six-foot tall invisible rabbit">>

<ROUTINE BALLROOM-F (RARG)
	 <COND (<==? .RARG ,M-LOOK>
		<TELL <GETP ,HERE ,P?LDESC> CR>
		<COND (,PARTY-OVER
		       <TELL
"The ballroom has emptied of the mob that inhabited it a few hours ago.
Only a few crushed potato chips and some discarded shoes remain to
testify to the revelry.">)
		      (ELSE
		       <TELL
"Elsewhere in this large ballroom, there are ">
		       <COND (<EQUAL? ,OVER-COUNT 0>
			      <TELL "scores of other ">)>
		       <TELL "party
guests dressed in all sorts of outlandish costumes">
		<COND (<PROB 50>
		       <TELL ", such as " <PICK-ONE ,COSTUMES>>)>
		<TELL ". On the dance
floor are " <COND (,RECORD-PLAYING? "many of the younger")
		  (ELSE "some of the older")> " dancers. ">
		<COND (,BAND-PLAYING?
		       <TELL "The band is playing \"" ,BAND-PLAYING? ".\"">)
		      (ELSE
		       <TELL
"A " 'RECORD-PLAYER " is playing \"" ,RECORD-PLAYING? "\" (the band is on
its break).">)>
		<CRLF>
		<TELL "On the
periphery of the room small groups can be seen, discussing everything
from politics to local scandals.">)>
		<WHO-DERE ,BALLROOM-1>
		<WHO-DERE ,BALLROOM-2>
		<WHO-DERE ,BALLROOM-3>
		<WHO-DERE ,BALLROOM-4>
		<WHO-DERE ,BALLROOM-5>
		<WHO-DERE ,BALLROOM-6>
		<WHO-DERE ,BALLROOM-7>
		<COND (<NOT <IN? ,VERONICA ,BALLROOM-8>>
		       <WHO-DERE ,BALLROOM-8>)>
		<WHO-DERE ,BALLROOM-9>
		<CRLF>)>>

<ROUTINE WHO-DERE (RM "AUX" F (CH? 0))
	<COND (<NOT <EQUAL? .RM ,HERE>>
	       <SET F <FIRST? .RM>>
	       <REPEAT ()
		       <COND (<NOT .F>
			      <COND (<G? .CH? 1> <TELL "are">)
				    (<EQUAL? .CH? 1> <TELL "is">)
				    (ELSE <RETURN>)>
			      <TELL " " <GETP .RM ,P?FDESC> ".">
			      <RETURN>)
			     (<AND <FSET? .F ,PERSON>
				   <NOT <EQUAL? .F ,LOCAL-BAND>>>
			      <COND (<EQUAL? .CH? 0> <TELL " ">)
				    (ELSE <TELL "and ">)>
			      <COND (<EQUAL? .CH? 0> <TELL CD .F " ">)
				    (ELSE <TELL D .F " ">)>
			      <SET CH? <+ .CH? 1>>)>
		       <SET F <NEXT? .F>>>)>>

<GLOBAL BAND-PLAYING? <>>
<GLOBAL RECORD-PLAYING? <>>

<ROUTINE I-MUSIC ("AUX" MINUTES (IB? <IN-BALLROOM? ,WINNER>))
	 <COND (,PARTY-OVER
		<SETG BAND-PLAYING? <>>
		<SETG RECORD-PLAYING? <>>
		<RFALSE>)>
	 <ENABLE <QUEUE I-MUSIC 10>>
	 <SET MINUTES <MOD ,PRESENT-TIME 60>>
	 <COND (<OR <G? .MINUTES 45> <G? ,PRESENT-TIME 764>>
		<SETG RECORD-PLAYING? <PICK-ONE ,RECORDS>>
		<COND (,BAND-PLAYING?
		       <COND (<G? ,PRESENT-TIME 764>
			      <MOVE ,LOCAL-BAND ,GLOBAL-OBJECTS>)
			     (ELSE
			      <MOVE ,LOCAL-BAND ,KITCHEN>)>
		       <SETG BAND-PLAYING? <>>
		       <COND (.IB?
			      <TELL
"The band is " <COND (<G? ,PRESENT-TIME 764> "going home")
		     (ELSE "starting its break")>
" now, but to fill the gap, " A ,RECORD-PLAYER "
has been started.  It's playing \"" ,RECORD-PLAYING? ".\"" CR>)>)
		      (.IB?
		       <TELL
"The record changes. It's now playing \"" ,RECORD-PLAYING? ".\"" CR>)>)
	       (ELSE
		<SETG BAND-PLAYING? <PICK-ONE ,TUNES>>
		<COND (,RECORD-PLAYING?
		       <MOVE ,LOCAL-BAND ,BALLROOM-2>
		       <SETG RECORD-PLAYING? <>>
		       <COND (.IB?
			      <TELL
"The band has returned from its break. They start their new set with
\"" ,BAND-PLAYING? ".\"" CR>)>)
		      (.IB?
		       <TELL
"After a short pause, the band begins to play \"" ,BAND-PLAYING? ".\"" CR>)>)>
	 <RFALSE>>

<GLOBAL RECORDS
	<LTABLE 0
		"Karma Chameleon"
		"Stairway to Heaven"
		"Light My Fire"
		"Pretty Woman">>

<GLOBAL TUNES
	<LTABLE 0
		"Michelle"
		"Singing in the Rain"
		"I Left My Heart in San Francisco"
		"Mona Lisa"
		"My Way"
		"Tennessee Waltz">>

\

<ROOM PATIO
      (IN ROOMS)
      (SYNONYM PATIO)
      (DESC "Patio")
      (LDESC
"This is a large flagstone patio east of the house. Paths lead
north to the back porch and south towards the front of the house. To
east is a pond, and in the distance you can see fences marking off
the boundaries of pastures.")
      (IN TO BALLROOM-6 IF FRENCH-DOOR IS OPEN)
      (WEST TO BALLROOM-6 IF FRENCH-DOOR IS OPEN)
      (EAST TO POND)
      (SOUTH TO OUTSIDE)
      (NORTH TO BACK-PORCH)
      (STATION PATIO)
      (LINE 4 ;OUTSIDE-LINE-C)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW FRENCH-DOOR)>

<ROOM OUTSIDE
      (IN ROOMS)
      (DESC "Outside House")
      (LDESC
"This is outside the house to the east, south of the patio
and west of the pond.")
      (WEST TO HALLWAY-19 IF EAST-DOOR IS OPEN)
      (NORTH TO PATIO)
      (EAST TO POND)
      (SOUTH TO CIRCLE)
      (STATION OUTSIDE)
      (LINE 4 ;OUTSIDE-LINE-C)
      (FLAGS OPENBIT)
      (GLOBAL WINDOW EAST-DOOR)>

<ROOM POND
      (IN ROOMS)
      (SYNONYM POND)
      (DESC "Pond")
      (LDESC
"This is a small pond, all of whose plants and animals have shut up shop
for the winter. A path leads northwest to the patio from here.")
      (NW TO PATIO)
      (WEST TO OUTSIDE)
      (EAST
"Even if you win the Pulitzer prize for this story, you still won't be
able to walk on water.")
      (STATION OUTSIDE)
      (LINE 4 ;OUTSIDE-LINE-C)
      (GLOBAL GLOBAL-PLANTS)
      (PSEUDO "POND" POND-PSEUDO)>

<ROUTINE POND-PSEUDO ()
	 <COND (<VERB? EXAMINE>
		<TELL "It's a small man-made pond." CR>)
	       (<VERB? THROUGH LEAP>
		<TELL
"You would get all wet and slimy." CR>)>>

<ROOM WEST-OF-HOUSE
      (IN ROOMS)
      (DESC "West of House")
      (LDESC
"Outside the house, just west of a door that opens onto a long east-west
hallway.")
      (EAST TO HALLWAY-1 IF WEST-DOOR IS OPEN)
      (IN TO HALLWAY-1 IF WEST-DOOR IS OPEN)
      (NORTH TO WEST-OF-GARAGE)
      (SOUTH TO CIRCLE)
      (GLOBAL WEST-DOOR)
      (LINE 4 ;OUTSIDE-LINE-C)
      (STATION WEST-OF-HOUSE)>

<ROOM WEST-OF-GARAGE
      (IN ROOMS)
      (DESC "West of Garage")
      (LDESC
"Outside the house, west of the garage. A path leads south to a door and
north to the back of the house. On the other side of the drive is a door
to one of the nearer horse barns.")
      (EAST "The garage doors are closed and locked.")
      (WEST TO BARN IF BARN-DOOR IS OPEN)
      (NORTH TO NORTH-OF-HOUSE)
      (SOUTH TO WEST-OF-HOUSE)
      (LINE 4 ;OUTSIDE-LINE-C)
      (STATION WEST-OF-GARAGE)
      (GLOBAL GARAGE-DOOR BARN-DOOR)
      (PSEUDO "BARN" BARN-F)>

<ROOM NORTH-OF-HOUSE
      (IN ROOMS)
      (DESC "North of House")
      (LDESC
"This is north of the house and west of the garden, where the hill
slopes down to pastures and paddocks. To the south is the house and
to the west the garage.")
      (WEST TO WEST-OF-GARAGE)
      (EAST TO GARDEN)
      (SE TO GARDEN)
      (LINE 4 ;OUTSIDE-LINE-C)
      (STATION NORTH-OF-HOUSE)>

<ROOM GARDEN
      (IN ROOMS)
      (SYNONYM GARDEN)
      (DESC "Garden")
      (LDESC
"This is a rain-drenched and soggy garden. Against the garage to the west is
a doghouse. Flagstone paths lead northeast and northwest, and a glass door
leads to the hallway.")
      (NW TO NORTH-OF-HOUSE)
      (NE TO BACK-PORCH)
      (EAST TO HALLWAY-14 IF SLIDING-DOOR IS OPEN)
      (SE TO HALLWAY-14 IF SLIDING-DOOR IS OPEN)
      (SOUTH TO WALKWAY)
      (ACTION GARDEN-F)
      (GLOBAL SLIDING-DOOR GLOBAL-PLANTS)
      (LINE 4 ;OUTSIDE-LINE-C)
      (STATION GARDEN)>

<ROUTINE GARDEN-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<COND (,DOG-FRIENDLY?
		       <TELL
"As you enter, the dog emerges briefly from his house, recognizes you,
and returns." CR CR>)
		      (ELSE
		       <MOVE ,DOG ,GARDEN>
		       <FCLEAR ,DOG ,NDESCBIT>
		       <ENABLE <QUEUE I-DOG 5>>
		       <TELL
"As you enter the garden, a large, rather vicious sounding dog emerges from "
THE ,DOGHOUSE ". He confronts you, growling and sniffing." CR CR>)>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <IN? ,DOG ,HERE> <VERB? WALK>>
		       <COND (,DOG-FRIENDLY?
			      <TELL
"The dog watches you go, his tail wagging." CR>
			      <RFALSE>)
			     (<AND ,OHERE
				   <EQUAL? ,PRSO
					   <DIR-FROM ,HERE ,OHERE>>>
			      <TELL
"The dog somewhat reluctantly allows you to retreat." CR>
			      <RFALSE>)
			     (ELSE
			      <TELL
"The dog bars your way, growling and sniffing. He obviously doesn't trust
you. His teeth are bared and his neck hair stands on end." CR>)>)>)>>

<ROUTINE I-DOG ("AUX" (D <LOC ,DOG>))
	 <COND (<NOT <FSET? ,DOG ,RMUNGBIT>>
		<MOVE ,DOG ,DOGHOUSE>
		<FSET ,DOG ,NDESCBIT>
		<COND (<EQUAL? ,HERE .D>
		       <SETG DOG-FRIENDLY? T>
		       <TELL
"Finally the dog decides you mean no harm, gives you one last sniff and
returns to his house." CR>)>)>>

<OBJECT DOGHOUSE
	(IN GARDEN)
	(DESC "doghouse")
	(SYNONYM DOGHOUSE HOUSE)
	(ADJECTIVE DOG)
	(ACTION DOGHOUSE-F)
	(FLAGS NDESCBIT OPENBIT CONTBIT)
	(CAPACITY 30)>

<ROUTINE DOGHOUSE-F ("OPTIONAL" (RARG <>))
	 <COND (<NOT .RARG>
		<COND (<VERB? THROUGH>
		       <TELL
"Your editor may want to send you to " THE ,DOGHOUSE ", but this is
ridiculous!" CR>)
		      (<VERB? EXAMINE>
		       <TELL
CTHE ,DOGHOUSE " is a miniature of the main house. It's quite cute. It's
also pretty large." CR>)
		      (<VERB? SMELL>
		       <TELL
"It smells of wet dog." CR>)
		      (<VERB? LOOK-INSIDE>
		       <COND (<IN? ,DOG ,DOGHOUSE>
			      <TELL
,THERE-IS "a large, wet Doberman pinscher in " THE ,DOGHOUSE "." CR>)
			     (ELSE
			      <TELL CTHE ,DOGHOUSE " is empty." CR>)>)>)>>

<OBJECT DOG
	(IN DOGHOUSE)
	(DESC "Doberman pinscher")
	(SYNONYM DOG DOBERMAN PINSCHER)
	(ADJECTIVE DOBERMAN GUARD WATCH)
	(ACTION DOG-F)
	(FLAGS NDESCBIT THE PERSON TAKEBIT TRYTAKEBIT)>

<GLOBAL DOG-FRIENDLY? <>>

<ROUTINE DOG-F ()
	 <COND (<OR <EQUAL? ,WINNER ,DOG>
		    <TALKING-TO? ,DOG>>
		<COND (,DOG-FRIENDLY?
		       <TELL
"The dog listens intently, but doesn't seem to understand you." CR>)
		      (ELSE
		       <TELL
"The dog growls." CR>)>)
	       (<VERB? ATTACK KILL KICK SLAP>
		<FSET ,DOG ,RMUNGBIT>
		<TELL
"Its ">
		<COND (,DOG-FRIENDLY?
		       <TELL "trust betrayed">)
		      (T
		       <TELL "suspicions confirmed">)>
		<TELL ", the dog bites you on the leg. It continues
to block the path." CR>)
	       (<VERB? GIVE SHOW>
		<TELL "The dog sniffs it, but doesn't want it." CR>)
	       (<VERB? TAKE MOVE>
		<TELL "This dog is as big as you are." CR>)
	       (<VERB? RUB>
		<COND (,DOG-FRIENDLY?
		       <TELL
"The dog wags his tail, spattering you with water. He enjoys being
patted." CR>)
		      (<FSET? ,DOG ,RMUNGBIT>
		       <TELL
"The dog bites your hand." CR>)
		      (ELSE
		       <TELL
"As your hand approaches, the dog snaps at it, more as a warning than as
a real attack." CR>)>)>>

;"RANDOM DOORS"

<OBJECT NORTH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "north hallway door")
	(SYNONYM DOOR)
	(ADJECTIVE NORTH HALLWAY)
	(UNLOCK HALLWAY-7)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT LOCKED NDESCBIT)>

<OBJECT WEST-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "west hall door")
	(SYNONYM DOOR)
	(ADJECTIVE WEST HALL)
	(UNLOCK HALLWAY-1)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT LOCKED NDESCBIT)>

<OBJECT WEST-BATH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "west bath door")
	(SYNONYM DOOR)
	(ADJECTIVE WEST)
	(UNLOCK WEST-BATH)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT LINEN-CLOSET-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "linen closet door")
	(SYNONYM DOOR)
	(ADJECTIVE LINEN CLOSET)
	(UNLOCK ROOMS) ;"no lock"
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT GARAGE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "garage door")
	(SYNONYM DOOR DOORS)
	(ADJECTIVE GARAGE)
	(FLAGS DOORBIT NDESCBIT LOCKED)>

<OBJECT WALKWAY-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "walkway door")
	(SYNONYM DOOR)
	(ADJECTIVE WALKWAY)
	(UNLOCK GARAGE)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT SUN-ROOM-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "sun room door")
	(SYNONYM DOOR)
	(ADJECTIVE SUN ROOM)
	(UNLOCK SUN-ROOM)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT)>

<OBJECT EAST-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "east hall door")
	(SYNONYM DOOR)
	(ADJECTIVE EAST HALL)
	(UNLOCK HALLWAY-19)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS LOCKED DOORBIT NDESCBIT)>

<OBJECT FRENCH-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "french door")
	(SYNONYM DOOR DOORS)
	(ADJECTIVE FRENCH)
	(UNLOCK BALLROOM-6)
	(FLAGS LOCKED DOORBIT NDESCBIT)>

<OBJECT SLIDING-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "sliding glass door")
	(SYNONYM DOOR WINDOW GLASS)
	(ADJECTIVE SLIDING GLASS)
	(UNLOCK HALLWAY-14)
	(FLAGS LOCKED DOORBIT NDESCBIT)>

<ROOM BARN
      (IN ROOMS)
      (SYNONYM BARN)
      (DESC "Barn")
      (EAST TO WEST-OF-GARAGE IF BARN-DOOR IS OPEN)
      (ACTION BARN-F)
      (GLOBAL BARN-DOOR)
      (STATION WEST-OF-GARAGE)
      (LINE 4 ;OUTSIDE-LINE-C)
      (PSEUDO "BARN" BARN-F)>

<OBJECT BARN-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "barn door")
	(SYNONYM DOOR)
	(ADJECTIVE BARN)
	(UNLOCK BARN)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS DOORBIT NDESCBIT LOCKED)>

<ROUTINE BARN-F (RARG)
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<TELL
"As you enter the barn, you see a horrific sight. Entering
in haste, and without light, " 'MICHAEL " and " 'ALICIA " scared " 'VERONICA
"'s horse
into a state of thrashing, rearing terror. It smashed the door of its
stall and trampled Michael, who lies in the straw, apparently dead. "
'ALICIA " is ">
		<COND (<IN? ,ALICIA ,HERE>
		       <TELL
"screaming in terror. The poor horse, its flanks heaving, is
in a corner looking fearfully from side to side." CR>)
		      (ELSE
		       <TELL "nowhere to be seen." CR>)>
		<SETG FLEEING? <>>
		<SETG DETECTIVE-SEEN ,DETECTIVE-CONVINCED>
		<SETG DETECTIVE-SEEN-CORPSE? T>
		<SETG DETECTIVE-SEEN-ROPE? T>
		<SETG DETECTIVE-SEEN-COAT? T>
		<SETG DETECTIVE-SEEN-GLASS? T>
		<SETG DETECTIVE-SEEN-HAIR? T>
		<SETG DETECTIVE-SEEN-CARD? T>
		<SETG DETECTIVE-SEEN-AGREEMENT? T>
		<SETG DETECTIVE-SEEN-TRUST-DOCUMENTS? T>
		<SETG DETECTIVE-SEEN-LIST? T>
		<SETG GLASS-ANALYZED? T>
		<SETG GLASS-ANALYZED-FOR-PRINTS? T>
		<SETG DETECTIVE-TOLD-ABOUT-RAIN? T>
		<COND (<IN? ,ALICIA ,BARN>
		       <SETG MICHAEL-DEAD? T>
		       <ARREST ,MICHAEL ,ALICIA>)
		      (ELSE
		       <FINISH>)>
		<RFATAL>)
	       (<NOT .RARG>
		<COND (<AND <VERB? THROUGH WALK-TO>
			    <EQUAL? ,PRSO ,PSEUDO-OBJECT>>
		       <PERFORM ,V?WALK-TO ,BARN>
		       <RTRUE>)
		      (<VERB? EXAMINE>
		       <TELL
"This is a well-kept, red-and-white-painted horse barn." CR>)>)>>

<GLOBAL MICHAEL-DEAD? <>>

;"end of places"