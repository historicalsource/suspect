"PEOPLE for M3
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

"Necessary Flags"

;<GLOBAL LOAD-MAX 100>
<GLOBAL LOAD-ALLOWED 100>

<ROUTINE GLOBAL-PERSON-F ("AUX" PER)
	 <COND (<VERB? $CALL>
		<SET PER <CHARACTERIZE ,PRSO>>
		<COND (<NEARBY? .PER>
		       <PERFORM ,V?$CALL .PER>
		       <RTRUE>)
		      (ELSE <TELL-ISNT-HERE .PER>)>)
	       (<VERB? GIVE>
		<TELL-ISNT-HERE ,PRSI>)
	       (<VERB? SLAP MUNG KILL ATTACK DANCE HELP
		       ACCUSE SEARCH LOOK-INSIDE>
		<TELL-ISNT-HERE ,PRSO>)
	       (<OR <AND <VERB? SHOW REVEAL>
			 <IN? ,PRSI ,GLOBAL-OBJECTS>
			 <SET PER ,PRSI>>
		    <AND <VERB? ASK-ABOUT TELL-ME ;PHONE>
			 <IN? ,PRSO ,GLOBAL-OBJECTS>
			 <SET PER ,PRSO>>>
		<COND (<EQUAL? .PER ,ME> <RFALSE>)
		      (<NEARBY? .PER>
		       <TELL
CD .PER " is waiting for you to come justify your interruption." CR>)
		      (ELSE
		       <TELL
"Your audience isn't listening." CR>)>)>>

<GLOBAL I-DONT-KNOW "\"I don't know ">
<GLOBAL ISNT-HERE " isn't here.">

<ROUTINE TELL-ISNT-HERE (PER)
	 <TELL CTHE .PER ,ISNT-HERE CR>>

<OBJECT HIM-HER
	(IN GLOBAL-OBJECTS)
	(SYNONYM HIM HER THEM GROUP)
	(DESC "him or her")
	(FLAGS NDESCBIT)>

<OBJECT YOU
	(IN GLOBAL-OBJECTS)
	(SYNONYM YOU YOURSELF HIMSELF HERSELF)
	(DESC "himself or herself")
	(FLAGS NDESCBIT)
	(ACTION YOU-F)>

<ROUTINE YOU-F ()
	 <COND (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSI ,YOU>>
		<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSO>
		<RTRUE>)
	       (<AND <VERB? TELL-ME> <EQUAL? ,PRSI ,YOU>>
		<PERFORM ,V?TELL-ME ,PRSO ,WINNER>
		<RTRUE>)>>

<OBJECT OBJECT-PAIR
	(DESC "such things")
	(ACTION OBJECT-PAIR-F)>

<ROUTINE LOCALIZE (P)
	 <COND (<AND <FSET? .P ,PERSON>
		     <IN? .P ,GLOBAL-OBJECTS>
		     <GETP .P ,P?CHARACTER>>
		<CHARACTERIZE .P>)
	       (ELSE .P)>>

<ROUTINE CHARACTERIZE (P)
	 <COND (<FSET? .P ,PERSON>
		<GET ,CHARACTER-TABLE <GETP .P ,P?CHARACTER>>)>>

<ROUTINE CHARACTERIZE? (P)
	 <COND (<SET P <GETP .P ,P?CHARACTER>>
		<GET ,CHARACTER-TABLE .P>)>>

<ROUTINE OBJECT-PAIR-F ("AUX" P1 P2)
	 <COND (<VERB? ARREST>
		<TELL-YOU-CANT
"arrest anyone. Only the police can do that. Besides, this
seems pretty far-fetched. It could only mean humiliation for you">)
	       (<G? <GET ,P-PRSO ,P-MATCHLEN> 2>
		<COND (<VERB? EXAMINE COMPARE>
		       <TELL
"That's more than one per eye. " ,YOU-ARENT "up to it." CR>)>
		<RTRUE>)>
	 <SET P1 <1 ,P-PRSO>>
	 <SET P2 <2 ,P-PRSO>>
	 <COND (<VERB? COMPARE>
		<PERFORM ,PRSA .P1 .P2>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<COND (<OR <NOT <FSET? .P1 ,PERSON>>
			   <NOT <FSET? .P2 ,PERSON>>>
		       <TELL-BORING>)
		      (<EQUAL? <LOC .P1> <LOC .P2>>
		       <TELL-YOU-CANT
"overhear or see anything out of the ordinary">)
		      (T <THEY-ARENT "together">)>)>>

<ROUTINE THEY-ARENT (STR)
	 <TELL "They aren't " .STR "." CR>>

<ROUTINE TELL-BORING ()
	 <TELL
"You see nothing interesting." CR>>

"People"

<OBJECT PLAYER
	(IN BALLROOM-9)
	(DESC "reporter")
	(SYNONYM REPORTER)
	(ACTION PLAYER-F)
	(FLAGS NDESCBIT TRANSBIT THE PERSON INVISIBLE)
	(CHARACTER 0)
	(SIZE 0)>

<GLOBAL PLAYER-HIDING <>>

<ROUTINE PLAYER-F ()
	 <COND (<EQUAL? ,WINNER ,PLAYER>
		<COND (<AND <VERB? EXAMINE> <EQUAL? ,PRSO ,PLAYER>>
		       <TELL
"You look pretty much like you always do, excepting the fact that you are
wearing a fairly ridiculous looking " 'COWBOY-COSTUME "." CR>)
		      (<EQUAL? ,NOT-ROPE ,PRSO ,PRSI>
		       <NOT-ROPE-F>)
		      (<AND <VERB? ACCUSE ARREST>
			    <EQUAL? ,PRSO ,PLAYER ,ME>>
		       <TELL "Turning yourself in, eh?" CR>)
		      (<AND <VERB? KILL ATTACK>
			    <IN? ,PRSO ,HERE>
			    <NOT <EQUAL? ,PRSO ,CORPSE ,VERONICA ,DOG>>>
		       <COND (<EQUAL? ,PRSO ,PLAYER>
			      <TELL "Suicide">)
			     (<FSET? ,PRSO ,PERSON>
			      <TELL <COND (<FSET? ,PLAYER ,TOLD>
					   "Another ")
					  (T "A ")>
				    'GLOBAL-MURDER>)
			     (T
			      <TELL "This">)>
		       <TELL " is not the way to clear up this mess." CR>)
		      (<AND <VERB? GIVE> <EQUAL? ,PRSI ,PLAYER>>
		       <TELL
"Taking up juggling, eh?" CR>)
		      (<AND <VERB? TAKE DANCE> <EQUAL? ,PRSO ,PLAYER>>
		       <TELL
"Usually, you say that to someone else." CR>)
		      (<AND <IN? ,DETECTIVE ,HERE>
			    <EQUAL? ,TARGET ,PLAYER>>
		       <COND (<VERB? SSHOW SGIVE> <RFALSE>)
			     (<AND <PLAYER-ARRESTED? ,DETECTIVE>
				   <VERB? WALK WALK-TO FOLLOW THROUGH>>
			      <RTRUE>)>)
		      (<AND <IN? ,DETECTIVE ,HERE>
			    <LAB-RESULTS-TO-PLAYER>>
		       <CRLF>
		       <RFALSE> ;"so what you were doing gets handled")
		      (<AND <IN? ,DUFFY ,HERE>
			    <EQUAL? ,TARGET ,PLAYER>>
		       <COND (<VERB? SSHOW SGIVE> <RFALSE>)
			     (<AND <PLAYER-ARRESTED? ,DUFFY>
				   <VERB? WALK WALK-TO FOLLOW THROUGH>>
			      <RTRUE>)>)
		      (<OR <AND <VERB? REVEAL> <EQUAL? ,PRSI ,PLAYER>>
			   <AND <VERB? TELL-ME TELL $CALL>
				<EQUAL? ,PRSO ,PLAYER>>>
		       <COND (<VERB? TELL>
			      <SETG P-CONT <>>
			      <SETG QUOTE-FLAG <>>)>
		       <INTERVIEW-SELF>)
		      (<OR <AND <VERB? REVEAL>
				<EQUAL? ,PRSO ,GLOBAL-MURDER>>
			   <AND <VERB? TELL-ME ASK-ABOUT>
				<EQUAL? ,PRSI ,GLOBAL-MURDER>>>
		       <COND (<NOT <FSET? ,PLAYER ,TOLD>>
			      <TELL
"What murder? " ,YOU-DONT "know anything about a murder." CR>)>)
		      (<OR <AND <VERB? THROW-AT POUR-ON>
				<EQUAL? ,PRSI ,PLAYER>>
			   <AND <VERB? RUB FOLLOW>
				<EQUAL? ,PRSO ,PLAYER>>>
		       <TELL ,YOU-ARENT "coordinated enough." CR>)
		      (<AND <VERB? ALARM>
			    <EQUAL? ,PRSO <> ,PLAYER ,ME>>
		       <TELL "Getting sleepy, huh?" CR>)>)
	       (ELSE <RFALSE>)>>

<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(DESC "yourself")
	(SYNONYM ME REPORTER MYSELF ;I)
	(ADJECTIVE COWBOY COWGIRL)
	(ACTION ME-F)
	(FLAGS NDESCBIT TRANSBIT PERSON)
	(CHARACTER 0)
	(SIZE 0)>

<ROUTINE ME-F ()
	 <COND (<VERB? RUB> <RFALSE>) 
	       (<EQUAL? ,ME ,PRSO ,PRSI>
		<PERFORM ,PRSA
			 <COND (<EQUAL? ,PRSO ,ME> ,PLAYER)
			       (T ,PRSO)>
			 <COND (<EQUAL? ,PRSI ,ME> ,PLAYER)
			       (T ,PRSI)>>
		<RTRUE>)>>

<OBJECT COWBOY-COSTUME
	(IN PLAYER)
	(SYNONYM COSTUME OUTFIT)
	(ADJECTIVE COWBOY COWGIRL MY WESTERN)
	(DESC "western outfit")
	(ACTION COWBOY-COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT WEARBIT)>

<ROUTINE COWBOY-COSTUME-F ()
	 <COND (<VERB? EXAMINE>
		<PERFORM ,V?EXAMINE <LOC ,PRSO>>
		<RTRUE>)
	       (<VERB? TAKE-OFF DROP>
		<TELL "The result would be embarrassing." CR>)>>

<OBJECT GUNBELT
	(IN PLAYER)
	(DESC "gunbelt")
	(SYNONYM GUNBELT HOLSTER LOOP LOOPS)
	(ADJECTIVE WESTERN LEATHER BELT)
	(ACTION GUNBELT-F)
	(CAPACITY 10)
	(FLAGS TAKEBIT BURNBIT WEARBIT CONTBIT OPENBIT)>

<ROUTINE GUNBELT-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This is fine western gunbelt, with a holster for a six-gun and loops
with lots of bullets. It's expertly tooled leather and is really the
nicest element of your costume.">
		<COND (<AND <NOT <FSET? ,GUNBELT ,WEARBIT>>
			    <NOT <IN? ,BULLET ,GUNBELT>>>
		       <TELL
" Now that you have it off, you can see that in the back one of the
cartridge loops is empty: a bullet is missing.">)>
		<CRLF>)
	       (<VERB? LOOK-INSIDE>
		<TELL
"Don't you remember, you left the gun at home. It was just a toy
anyway." CR>)
	       (<AND <VERB? PUT>
		     <NOT <EQUAL? ,PRSO ,BULLET>>
		     <EQUAL? ,PRSI ,GUNBELT>>
		<TELL-WONT-FIT>)>>

<OBJECT PEN
	(IN PLAYER)
	(DESC "pen")
	(SYNONYM PEN)
	(ACTION PEN-F)
	(FLAGS TAKEBIT)>

<ROUTINE PEN-F ()
	 <COND (<AND <VERB? WRITE> <EQUAL? ,PRSO ,PEN>>
		<COND (<IN? ,NOTEBOOK ,PLAYER>
		       <PERFORM ,V?WRITE ,NOTEBOOK ,PEN>
		       <RTRUE>)
		      (T
		       <TELL "On your cuff, no doubt." CR>)>)>>

<OBJECT NOTEBOOK
	(IN PLAYER)
	(DESC "notebook")
	(SYNONYM NOTEBOOK NOTES)
	(ADJECTIVE REPORTER)
	(FLAGS TAKEBIT BURNBIT READBIT)
	(ACTION NOTEBOOK-F)
	(TEXT
"The notebook contains a few doodles, a truncated phrase or two, and
little else.")>

<ROUTINE NOTEBOOK-F ()
	 <COND (<OR <VERB? WRITE>
		    <AND <VERB? TAKE> <IN? ,NOTEBOOK ,PLAYER>>>
		<COND (<IN? ,PEN ,PLAYER>
		       <TELL
"The notebook now contains more doodles, phrases, and such than before." CR>)
		      (ELSE
		       <TELL
,YOU-DONT-HAVE "a writing implement." CR>)>)>>

<OBJECT YOUR-COAT
	(IN EAST-COAT-CLOSET)
	(DESC "reporter's overcoat")
	(SYNONYM OVERCOAT COAT)
	(ADJECTIVE PLAYER REPORTER MY)
	(ACTION YOUR-COAT-F)
	(FLAGS TAKEBIT BURNBIT OPENBIT TRANSBIT CONTBIT)>

<ROUTINE YOUR-COAT-F ()
	 <COND (<VERB? THROUGH>
		<PERFORM ,V?WEAR ,YOUR-COAT>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<TELL
,THERE-IS "nothing in the coat." CR>)
	       (<VERB? SMELL>
		<TELL
"It smells slightly damp, which is expected, as it was raining when you
arrived." CR>)
	       (<VERB? RUB>
		<TELL
"It feels slightly damp. It hasn't finished drying off from the rain." CR>)>>

\

<OBJECT GLOBAL-MICHAEL
	(IN GLOBAL-OBJECTS)
	(DESC "Michael")
	(SYNONYM WELLMAN SHEIK MICHAEL MIKE)
	(ADJECTIVE MR MICHAEL MIKE)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 1)>

<OBJECT MICHAEL
	(IN BALLROOM-8)
	(DESC "Michael")
	(LDESC "Michael, costumed as a sheik, is here.")
	(SYNONYM WELLMAN SHEIK MICHAEL MIKE)
	(ADJECTIVE MR MICHAEL MIKE)
	(ACTION MICHAEL-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 1)>

<GLOBAL MICHAEL-SEEN 0>

"add verbs that in general non-player ,winner doesn't want to handle here."

<ROUTINE DONT-HANDLE? ()
	 <COND (<VERB? WHAT SGIVE SSHOW FIND DANCE EXAMINE 
		       IS $REVEAL THANKS>
		<RTRUE>)
	       (<AND <VERB? TELL-ME>
		     <EQUAL? ,PRSO ,ME ,PLAYER>>
		<RTRUE>)>>

<ROUTINE MICHAEL-F ()
	 <COND (<EQUAL? ,WINNER ,MICHAEL>
		<COND (<VERB? HELLO>
		       <COND (<FSET? ,MICHAEL ,TOLD>
			      <TELL
"\"How could this have happened? " ,YOU-MUST "feel lucky, something like
this happening when you're here, but it's horrible, horrible!\"" CR>)
			     (T
			      <TELL
"\"Glad you could make it. I don't see where you'll find a story here,
but you'll have fun, at least.\"" CR>)>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL 'MICHAEL " pays you no heed." CR>)>)
	       (<AND <VERB? $REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<ENABLE <QUEUE I-MICHAEL-TO-GARAGE 5>>
		<COND (<REVEAL-MURDER ,MICHAEL>
		       <COND (<IN? ,WINNER ,HERE>
			      <TELL
CD ,WINNER " breaks the news of the murder to " 'MICHAEL ", who responds
jokingly, then realizes that " D ,WINNER " is serious. He seems to be
in a state of shock." CR>)
			     (<NEARBY? ,MICHAEL>
			      <TELL
CD ,WINNER " has just told " 'MICHAEL " something that seems to have
shocked him terribly." CR>)>)
		      (ELSE
		       <COND (<IN? ,WINNER ,HERE>
			      <TELL
CD ,WINNER " breaks the news of the murder to " 'MICHAEL ". He already
knows about it, and replies scornfully." CR>)>)>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<ENABLE <QUEUE I-MICHAEL-TO-GARAGE 5>>
		<COND (<REVEAL-MURDER ,MICHAEL>
		       <TELL
"\"What! You're kidding... No, you're not, are you?\" He seems to be
in a state of shock." CR>)
		      (ELSE
		       <TELL
"\"I already know. You're a cruel person to harp on it.\"" CR>)>)
	       (<VERB? EXAMINE>
		<TELL
'MICHAEL " Wellman is a tall, greying man about forty years of age. He is
costumed as an Arab sheik straight out of a bad movie of the twenties." CR>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,MICHAEL>>
		<COND (<NOT <FSET? ,PRSI ,PERSON>>
		       <COND (<AND <EQUAL? ,PRSI ,DRINK>
				   <IN-BALLROOM? ,VERONICA>>
			      <TELL
"\"" 'VERONICA "'s drink? She was drinking a Singapore Sling.\"" CR>)
			     (<EQUAL? ,PRSI ,HORSE>
			      <TELL
"\"'Lurking Grue' is " 'VERONICA "'s prize show jumper. He's really quite a
beautiful animal. He's coal black, you can barely see him in the dark.\"" CR>)
			     (<EQUAL? ,PRSI ,GLOBAL-MURDER>
			      <COND (<FSET? ,PRSO ,TOLD>
				     <TELL
"\"You reporters have all the sensitivity of buffalo. Can't you leave
me alone?\"" CR>)
				    (T
				     <TELL
"\"Murder?\"" CR>)>)
			     (ELSE
			      <TELL
"\"I'm not sure what I can tell you about " THE ,PRSI ".\"" CR>)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"I thought you were a friend of " 'VERONICA "'s. Didn't you go to school
together or something?\"" CR>)
		      (<EQUAL? ,PRSI ,MICHAEL ,GLOBAL-MICHAEL>
		       <TELL
"\"What can I say? I didn't realize the rich had to serve any function
but decoration and public amusement. That's what I do, and I take my job
seriously.\" He smiles." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA ,VERONICA ,CORPSE>
		       <COND (<FSET? ,MICHAEL ,TOLD>
			      <TELL
'MICHAEL " stares at you. \"What a strange question! She was my wife, and
I loved her, and she's dead! Murdered! Why would anyone want to kill
her?\" His words trail off. \"I can't understand this. Things were so
good for us...\"" CR>)
			     (<IN? ,VERONICA ,HERE>
			      <TELL
'MICHAEL " hugs " 'VERONICA". He smiles." CR>)
			     (<IN-BALLROOM? ,VERONICA>
			      <TELL
"\"That's her over there. I guess she's going to try to get that costume
cleaned up.\"" CR>)
			     (T
			      <TELL
"\"That's an odd question. She's my wife: I love her.\"">
			      <COND (<G? ,PRESENT-TIME 555>
				     <TELL
" He looks around
quizzically. \"I wonder where she's gotten off to?\"">)>
			      <CRLF>)>)
		      (<EQUAL? ,PRSI ,ALICIA ,GLOBAL-ALICIA>
		       <TELL
"\"She's an excellent horsewoman, and a good friend of " 'VERONICA"'s. She
boards her horses here, so she's here a lot.\"" CR>)
		      (<EQUAL? ,PRSI ,COL-MARSTON ,GLOBAL-COL-MARSTON>
		       <TELL
"\"" 'COL-MARSTON "? One of the ablest men I know. He's done a lot with our family
trust, and I can always count on his advice.\"" CR>)
		      (<EQUAL? ,PRSI ,SEN-ASHER ,GLOBAL-SEN-ASHER>
		       <TELL
"\"" 'VERONICA " and I are quite fond of him. With a little luck he'll be
president some day. The man has a lot on the ball.\"" CR>)
		      (<EQUAL? ,PRSI ,OSTMANN ,GLOBAL-OSTMANN>
		       <TELL
"\"" 'OSTMANN " would love to buy the farm, but we turned him down. Our roots are
here, even though this part of the county is getting so suburban. Some
think it's past time to make a move upcounty. Most of the Club has
moved already. " 'OSTMANN " wanted to develop the land as town houses.
Imagine that!\"" CR>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
'MICHAEL " glances toward " D ,PRSI ". \"What a rude question! Are you hoping
I'll say something derogatory and start a shouting match?\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
"\"It's common knowledge Richard and I have our disagreements. " 'VERONICA "
tries to keep him in line, but you know how it is sometimes between brother
and sister. Linda is another problem. She just doesn't fit in this sort of
group.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
,I-DONT-KNOW "why Richard keeps company with her. Well, I suppose I do.
But have you ever talked to her? With a
good tail wind she has an outside chance at a two-digit IQ.\" He shakes his
head ruefully. \"Richard is still a bit immature.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
"\"The fellow is a crook. I hear he's going up before" ,REAL-ESTATE-BOARD
" for unethical practices. He and " 'OSTMANN " hate each other, if
you believe the stories. I certainly didn't invite him, but
I'm not going to throw him out and make a scene.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"" 'BUTLER " has been with us forever. He worked for " 'VERONICA"'s
parents when they were still alive. He's lived on the farm for most of
his life.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <I-DONT-KNOW-ABOUT "him: " <>>
		       <TELL
'VERONICA " hired him from some agency for
the party. He mixes a pretty good martini, I can say that.\"" CR>)
		      (ELSE
		       <TELL
"\"I can't say much one way or the other.\"" CR>)>)
	       (<OR <VERB? SHOW>
		    <AND <VERB? $DISCOVER>
			 <IN? ,MICHAEL ,HERE>
			 <NOT <IN? ,MICHAEL ,OFFICE>>>>
		<COND (<EQUAL? ,PRSO ,CORPSE>
		       <COND (<REVEAL-MURDER ,MICHAEL>
			      <TELL
'MICHAEL " stares at the corpse, stunned. He rushes over, cradles the body
in his arms, and seems about to cry. Then, suddenly, he turns to you: \"Did
you do this?" ,CALLING-POLICE>
			      <COND (<GLOBAL-IN? ,TELEPHONE ,HERE>
				     <TELL-MICHAEL-CALLS-POLICE>)>
			      <CRLF>)
			     (ELSE
			      <TELL
"He looks away. \"I can't bear it,\" he says, trying to compose
himself." CR>)>)
		      (<FSET? ,PRSO ,MICHAELBIT>
		       <FCLEAR ,PRSO ,MICHAELBIT>
		       <SETG MICHAEL-SEEN <+ ,MICHAEL-SEEN 1>>
		       <ENABLE <QUEUE I-FLEE 5>>
		       <TELL
"\"I have no idea what this has to do with me.\"" CR>)>)>>

<GLOBAL THREE-STOOGES-IN-OFFICE? <>>

<ROUTINE TELL-MICHAEL-CALLS-POLICE ()
	 <TELL
'MICHAEL " picks up the telephone
and calls the police.">
	 <COND (<FSET? ,MICHAEL ,TOLD>
		<TELL " His voice breaks towards the end.">)>
	 <RTRUE>>

<ROUTINE G-MICHAEL (GARG "AUX" (L <LOC ,MICHAEL>) (BODY? <>))
	 <COND (<NOT .GARG> <IMOVEMENT ,MICHAEL G-MICHAEL>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<COND (<EQUAL? .L ,HERE ,OFFICE> <RFALSE>)
		      (<EQUAL? .L ,LIBRARY>
		       <FCLEAR ,LIBRARY-DOOR ,LOCKED>
		       <RFALSE>)>
		<TELL 'MICHAEL " is looking ">
		<COND (<EQUAL? .L ,GARAGE>
		       <TELL
"angry and impatient." CR>)
		      (<FSET? ,MICHAEL ,TOLD>
		       <TELL
"impatient, nervous, and distraught." CR>)
		      (ELSE
		       <TELL "very bored with all this." CR>)>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<AND <EQUAL? .L ,BALLROOM-5>
			    <IN? ,ALICIA ,BALLROOM-5>>
		       <THEY-DANCE ,MICHAEL>)
		      (<AND <EQUAL? .L ,BALLROOM-8>
			    <NOT ,PARTY-OVER>>
		       <NEW-SCRIPT ,MICHAEL ,MICHAEL-LOOP>
		       <RFALSE>)
		      (<AND <EQUAL? .L ,BALLROOM-9>
			    <NOT ,OFFICE-EXPEDITION?>>
		       <GOALS? ,MICHAEL <>>
		       <ESTABLISH-GOAL ,COL-MARSTON ,BALLROOM-9 T>
		       <ESTABLISH-GOAL ,COCHRANE ,BALLROOM-9 T>
		       <ENABLE <QUEUE I-ARGUMENT 5>>
		       <RFALSE>)
		      (<EQUAL? .L ,GARAGE>
		       <ENABLE <QUEUE I-MICHAEL-HIDES-FOLDER 1>>
		       <RFALSE>)
		      (<AND <EQUAL? .L ,HALLWAY-3>
			    <NOT ,THREE-STOOGES-IN-OFFICE?>>
		       <GOALS? ,MICHAEL <>>
		       <COND (<AND <IN? ,COCHRANE ,HALLWAY-3>
				   <IN? ,COL-MARSTON ,HALLWAY-3>>
			      <GANGS-ALL-HERE>)>)
		      (<EQUAL? .L ,OFFICE>
		       <SETG THREE-STOOGES-IN-OFFICE? T>
		       <ESTABLISH-GOAL ,MICHAEL ,LIVING-ROOM>
		       <GRAB-ATTENTION ,MICHAEL>
		       <COND (<NOT ,MURDER-PUBLIC?>
			      <SET BODY? <EQUAL? <META-LOC ,CORPSE> ,OFFICE>>
			      <COND (.BODY?
				     <FCLEAR ,MICHAEL ,TOLD>
				     <REVEAL-MURDER ,MICHAEL>)
				    (ELSE
				     <SETG MURDER-PUBLIC? T>
				     <ENABLE <QUEUE I-POLICE-ARRIVE 25>>)>
			      <COND (<EQUAL? .L ,HERE>
				     <COND (.BODY?
					    <TELL-LOOK-AROUND>
					    <TELL
"The three of them start to search the room, examine the body, and so on.
Then " 'MICHAEL " says, \"Wait! This is a job for the police! Don't touch
anything!\" The others agree, though " D ,COCHRANE " takes some convincing. ">
					    <TELL-MICHAEL-CALLS-POLICE>
					    <CRLF>)
					   (ELSE
					    <TELL-LOOK-AROUND>
					    <TELL
'MICHAEL " is particularly shocked. \"There must have
been a prowler in here, or maybe some kids out for a thrill.\" He looks
around some more. ">
					    <COND (<IN? ,FAIRY-MASK .L>
						   <TELL
"\"" 'VERONICA "'s mask is here!\" he says. ">)>
					    <COND (<IN? ,ROPE .L>
						   <TELL
"\"And isn't that your rope?\" He asks you. ">)>
					    <TELL
"He seems puzzled. \"Nothing seems to be taken." ,CALLING-POLICE
" He does so." CR>)>
				     <RTRUE>)>)>)
		      (<EQUAL? .L ,LIBRARY>
		       <COND (<IN? ,COL-MARSTON ,LIBRARY>
			      <LIBRARY-MEETING ,MICHAEL>)
			     (ELSE
			      <GOALS? ,MICHAEL <>>
			      <RFALSE>)>)
		      (<AND ,FLEEING? <EQUAL? .L ,SITTING-ROOM>>
		       <UNPRIORITIZE ,MICHAEL>
		       <COND (<IN? ,ALICIA .L>
			      <GOALS? ,ALICIA T>
			      <ESTABLISH-GOAL ,ALICIA ,BARN T>
			      <ESTABLISH-GOAL ,MICHAEL ,BARN T>)
			     (T
			      <GOALS? ,MICHAEL <>>)>
		       <RFALSE>)
		      (<EQUAL? .L ,BARN>
		       <GOALS? ,MICHAEL <>>
		       <BARN-DANCE ,MICHAEL>)>)>>

<ROUTINE TELL-LOOK-AROUND ()
	 <TELL
'MICHAEL " and the others look around the room, startled. They see the total
wreck of the office. ">>

<ROUTINE I-MICHAEL-HIDES-FOLDER ()
	 <COND (<AND <EQUAL? ,HERE ,GARAGE>
		     <NOT ,PLAYER-HIDING>>
		<COND (<LISTENING? ,MICHAEL>
		       <TELL "\"Get out of here!\" " 'MICHAEL " screams." CR>
		       <RTRUE>)>
		<SETG MICHAEL-TO-GARAGE? <>>
		<ENABLE <QUEUE I-MICHAEL-TO-GARAGE 25>>
		<ESTABLISH-GOAL ,MICHAEL ,BALLROOM-9 T>
		<GRAB-ATTENTION ,MICHAEL>
		<TELL
'MICHAEL " eyes you suspiciously. \"What are you doing in here?\" he asks.">
		<COND (<OR <FSET? ,BMW-TRUNK ,OPENBIT>
			   <IN? ,CROWBAR ,PLAYER>
			   <FIRST? ,BMW-TRUNK>>
		       <TELL
" \"Have you been fooling with my car? What are you doing in here! I'll
have you thrown out!\" He seems serious.">)>
		<COND (<FSET? ,MICHAEL ,TOLD>
		       <TELL
" \"Are you trying to hide something? You've been acting pretty oddly.
Did you kill my wife?\" He breaks off, torn between several courses of
action.">)>
		<TELL
" Finally he just says \"Get out of here!\"" CR>)
	       (ELSE
		<ENABLE <QUEUE I-LIBRARY-MEETING 20>>
		<COND (<AND <NOT <FIRST? ,BMW-TRUNK>>
			    <NOT <FSET? ,BMW-TRUNK ,OPENBIT>>>
		       <FSET ,BMW-TRUNK ,LOCKED>
		       <MOVE ,TRUST-FOLDER ,BMW-TRUNK>
		       <FCLEAR ,TRUST-FOLDER ,INVISIBLE>
		       <COND (<EQUAL? ,HERE ,GARAGE>
			      <TELL-MIKE-WALKS>
			      <TELL
", and after a few seconds, closes it again. Unfortunately, the trunk lid
blocks your view of what he was doing when the trunk was open." CR>)>)
		      (ELSE
		       <REMOVE ,TRUST-FOLDER>
		       <COND (<EQUAL? ,HERE ,GARAGE>
			      <TELL-MIKE-WALKS>
			      <TELL
", and becomes extremely agitated. He looks around, fails to see you, and
stands for a moment, confused." CR>)>)>)>>

<ROUTINE TELL-MIKE-WALKS ()
	 <TELL
'MICHAEL " walks to the rear of the BMW, ">
	 <COND (<FSET? ,BMW-TRUNK ,OPENBIT>
		<TELL "notices the trunk is open">)
	       (T
		<TELL "opens the trunk">)>>

<ROUTINE I-LIBRARY-MEETING ()
	 %<DEBUG-CODE
	   <COND (,DEBUG
		  <TELL "[Michael and Marston to Library]" CR>)>>
	 <ESTABLISH-GOAL ,MICHAEL ,LIBRARY T>
	 <ESTABLISH-GOAL ,COL-MARSTON ,LIBRARY T>
	 <RFALSE>>

<ROUTINE TELL-THREE-STOOGES ()
	 <TELL 'MICHAEL ", " 'COL-MARSTON ", and " 'COCHRANE>>

<ROUTINE TELL-THREE-ARRIVE (KNEW?)
	 <COND (<EQUAL? ,HERE ,OFFICE ,HALLWAY-3>
		<FSET ,PLAYER ,TOLD>
		<TELL-THREE-STOOGES>
		<TELL
" arrive at the office door.
" 'COL-MARSTON " glances through the door. \"Look in there!\" he cries.
\"The place is a shambles!">
		<COND (.KNEW?
		       <TELL " It must be true, then!">)>
		<COND (<EQUAL? ,HERE ,OFFICE>
		       <TELL
"\" They see you">)
		      (ELSE
		       <TELL
"\" " 'MICHAEL " and " 'COCHRANE " look startled as well">)>
		<TELL ,THREE-CROWD CR>)
	       (<CORRIDOR-LOOK ,MICHAEL>
		<TELL-THREE-STOOGES>
		<TELL
" are down the hall, in front of the
office. " 'COL-MARSTON " shouts" ,THREE-CROWD CR>)>>

<GLOBAL THREE-CROWD ", and the three of them crowd into the room.">

<GLOBAL GANG-BEEN-TO-OFFICE? <>>

<ROUTINE GANGS-ALL-HERE ("AUX" (KNEW <>))
	 <COND (,GANG-BEEN-TO-OFFICE? <RFALSE>)>
	 <SETG GANG-BEEN-TO-OFFICE? T>
	 <UNPRIORITIZE ,MICHAEL>
	 <ESTABLISH-GOAL ,MICHAEL ,OFFICE T>
	 <UNPRIORITIZE ,COCHRANE>
	 <ESTABLISH-GOAL ,COCHRANE ,OFFICE T>
	 <UNPRIORITIZE ,COL-MARSTON>
	 <ESTABLISH-GOAL ,COL-MARSTON ,OFFICE T>
	 <COND (<OR <FSET? ,MICHAEL ,TOLD>
		    <FSET? ,COCHRANE ,TOLD>
		    <FSET? ,COL-MARSTON ,TOLD>>
		<SET KNEW T>)>
	 %<DEBUG-CODE
	   <COND (<AND ,GOSSIP <NOT .KNEW>>
		  <TELL
"[Michael, Marston, Cochrane find out at office]" CR>)>>
	 <COND (<EQUAL? <META-LOC ,CORPSE> ,OFFICE>
		<FSET ,MICHAEL ,TOLD>
		<FSET ,COL-MARSTON ,TOLD>
		<FSET ,COCHRANE ,TOLD>)>
	 <COND (<FSET? ,SOUTH-OFFICE-DOOR ,OPENBIT>
		<TELL-THREE-ARRIVE .KNEW>)
	       (T
		<FCLEAR ,SOUTH-OFFICE-DOOR ,LOCKED>
		<FSET ,SOUTH-OFFICE-DOOR ,OPENBIT>
		<COND (<EQUAL? ,HERE ,OFFICE>
		       <TELL
"Outside, you hear voices. ">
		       <COND (<NOT .KNEW>
			      <TELL
			  " You hear someone say," ,LET-ME ,THERE-IS "a pause."
,I-HAD-THEM "Another pause. The doorknob turns." ,WAIT-A-MINUTE>)>
		       <TELL "The door opens, revealing ">
		       <TELL-THREE-STOOGES>
		       <TELL ". They crowd forward." CR>)
		      (<EQUAL? ,HERE ,HALLWAY-3>
		       <FSET ,PLAYER ,TOLD>
		       <COND (.KNEW
			      <TELL
'MICHAEL " says, \"If it's true, I can take it, just let me go in.\" He
opens the door, and the three of them crowd around." CR>)
			     (T
			      <TELL
'MICHAEL " says," ,LET-ME "He roots around underneath
his robes for a moment, obviously trying to find his keys. He clearly
can't find them." ,I-HAD-THEM "He gets more and more
frantic." ,WAIT-A-MINUTE 'MICHAEL " throws open the door of the office, the others crowding
closely around him." CR>)>)
		      (<CORRIDOR-LOOK ,MICHAEL>
		       <TELL
"You see, at the office door, a group which includes ">
		       <TELL-THREE-STOOGES>
		       <TELL ". " 'MICHAEL>
		       <COND (<NOT .KNEW>
			      <TELL " is looking for something in his
robes, getting more and more frantic. Then, suddenly, he">)>
		       <TELL " opens the door,
and the other two crowd around him, staring into the office." CR>)>)>>

<GLOBAL LET-ME " \"Let me unlock this door...\" ">
<GLOBAL I-HAD-THEM " \"I had them! I unlocked the wine cellar only an hour
ago; Smythe needed to get to it! My keys are gone!\" ">
<GLOBAL WAIT-A-MINUTE " \"Wait a minute! This door isn't
locked! Something's going on here!\" ">

<ROUTINE LIBRARY-MEETING (LAST "AUX" FIRST)
	 <COND (<EQUAL? .LAST ,MICHAEL> <SET FIRST ,COL-MARSTON>)
	       (ELSE <SET FIRST ,MICHAEL>)>
	 <FCLEAR ,LIBRARY-DOOR ,OPENBIT>
	 <FCLEAR ,LH-DOOR ,OPENBIT>
	 <FSET ,LIBRARY-DOOR ,LOCKED>
	 <FSET ,LH-DOOR ,LOCKED>
	 <MOVE ,INVESTOR-LIST ,COL-MARSTON>
	 <ENABLE <QUEUE I-END-MEETING 2>>
	 <COND (<NOT <EQUAL? <META-LOC ,PLAYER> ,LIBRARY>>
		<RFALSE>)>
	 <TELL D .LAST " enters the library. ">
	 <COND (<EQUAL? ,PLAYER-HIDING ,CHAIR>
		<TELL
'MICHAEL " and " 'COL-MARSTON " greet each other, then glance suspiciously
around the room. They do not see you hiding behind the overstuffed
chair. " 'MICHAEL " closes and locks the doors. He then passes the Colonel a
piece of paper, which the latter avidly scans, then folds up and
stuffs into a pocket. Both men grin." CR>)
	       (<EQUAL? <META-LOC ,PLAYER> ,LIBRARY>
		<GRAB-ATTENTION ,MICHAEL 2>
		<GRAB-ATTENTION ,COL-MARSTON 2>
		<TELL
"He seems surprised to see you. " D .FIRST "
looks at him and shrugs his shoulders. \"Please leave us. We have some
private business to transact. I'm sure you understand,\" says " 'MICHAEL ".
The two of them unceremoniously show you the door." CR>
		<GOTO ,HALLWAY-16>
		<RTRUE>)>>

<ROUTINE I-END-MEETING ()
	 <UNPRIORITIZE ,COL-MARSTON>
	 <ESTABLISH-GOAL ,COL-MARSTON ,BALLROOM-8 T>
	 <UNPRIORITIZE ,MICHAEL>
	 <ESTABLISH-GOAL ,MICHAEL ,BALLROOM-8 T>
	 <RFALSE>>

<GLOBAL OFFICE-EXPEDITION? <>>

<ROUTINE I-ARGUMENT ("AUX" S (FLG <>))
	 <COND (<AND <NOT ,OFFICE-EXPEDITION?>
		     <NOT <FSET? ,MICHAEL ,TOLD>>
		     <IN? ,MICHAEL ,BALLROOM-9>
		     <IN? ,COL-MARSTON ,BALLROOM-9>
		     <IN? ,COCHRANE ,BALLROOM-9>>
		<SET S <GET ,ARGUMENT-TABLE ,ARGUMENT-COUNT>>
		<COND (<EQUAL? ,HERE ,BALLROOM-9>
		       <SET FLG T>
		       <TELL .S CR>)
		      (<IN-BALLROOM? ,PLAYER>
		       <SET FLG T>
		       <TELL
,SEEMS-TO-BE A ,DISCUSSION " going on at the bar." CR>)
		      (<EQUAL? ,ARGUMENT-COUNT 0>
		       <SETG ARGUMENT-POSTPONE <- ,ARGUMENT-POSTPONE 1>>
		       <COND (<G? ,ARGUMENT-POSTPONE 0>
			      <QUEUE I-ARGUMENT 2>
			      <RFALSE>)>)>
		<SETG ARGUMENT-COUNT <+ ,ARGUMENT-COUNT 1>>
		<COND (<SET S <GET ,ARGUMENT-TABLE ,ARGUMENT-COUNT>>
		       <QUEUE I-ARGUMENT 1>)
		      (ELSE
		       <SETG ARGUMENT-COUNT 0> ;"argument over"
		       <SETG OFFICE-EXPEDITION? T>
		       <THIS-IS-S-HE ,MICHAEL>
		       <ESTABLISH-GOAL ,MICHAEL ,HALLWAY-3 T>
		       <ESTABLISH-GOAL ,COL-MARSTON ,HALLWAY-3 T>
		       <ESTABLISH-GOAL ,COCHRANE ,HALLWAY-3 T>)>
		<RETURN .FLG>)
	       (<FSET? ,MICHAEL ,TOLD>
		<SETG OFFICE-EXPEDITION? T>
		<SETG ARGUMENT-COUNT 0>
		<RFALSE>)
	       (ELSE
		<QUEUE I-ARGUMENT 5>
		<RFALSE>)>>

<GLOBAL ARGUMENT-POSTPONE 5>
<GLOBAL ARGUMENT-COUNT 0>

<GLOBAL ARGUMENT-TABLE
	<TABLE
"Some guests are discussing this year's horse sales. Col. Marston
maintains that no stallion went for more than one
hundred thousand dollars, while Cochrane contends that he's wrong."

"Michael joins in the discussion. \"I recall a black stallion that
went for a high price last year. It was probably over a hundred thousand.\"
Col. Marston glares at him."

"Col. Marston says, \"I have a good memory for figures. The top price last
year was ninety two thousand. I even remember the horse, it was a chestnut,
about fifteen hands. Beautiful animal!\" Michael nods, apparently convinced.
Cochrane glances at Michael, feeling betrayed. \"Nonsense,\" he says, angrily."

"Cochrane takes another gulp of his drink. \"You're just
getting senile, Colonel. It was a black stallion, and I remember who bought
it. It was Jeffries! So there!\" He makes a gesture of
finality, almost spilling his drink on Marston, who is beginning to get
angry himself."

"Michael steps between them. \"Look here,\" he says, \"No need to fight.
We've got all the auction records in the office. Veronica
gets everything published. We can settle
this like gentlemen. Okay?\" Cochrane seems mollified, and
Marston comments under his breath, \"Some of us aren't gentlemen.\"
They head off towards the office."

	<>>>

<GLOBAL MURDER-PUBLIC? <>>

\

<ROUTINE VERONICA-UNMASKED? ()
	 <EQUAL? <GETP ,VERONICA ,P?SDESC> ,VERONICA-SDESC>>

<ROUTINE VERONICA-UNMASKS ()
	 <FCLEAR ,VERONICA ,THE>
	 <PUTP ,VERONICA ,P?SDESC ,VERONICA-SDESC>
	 <FCLEAR ,GLOBAL-VERONICA ,THE>
	 <PUTP ,GLOBAL-VERONICA ,P?SDESC ,VERONICA-SDESC>>

<GLOBAL VERONICA-SDESC "Veronica">

<OBJECT GLOBAL-VERONICA
	(IN GLOBAL-OBJECTS)
	(DESC "Veronica")
	(SDESC "fairy queen")
	(SYNONYM VERONICA TITANIA QUEEN ASHCROFT ;WELLMAN)
	(ADJECTIVE VERONICA MRS MS FAIRY WIFE)
	(ACTION GLOBAL-VERONICA-F)
	(GENERIC GENERIC-VERONICA-F)
	(FLAGS TRANSBIT PERSON FEMALE THE)
	(CHARACTER 2)>

<ROUTINE GLOBAL-VERONICA-F ()
	 <COND (<AND <NOT <LOC ,VERONICA>>
		     <EQUAL? <META-LOC ,CORPSE> ,HERE>
		     <NOT <VERB? TELL-ME ASK-ABOUT>>>
		<PERFORM ,PRSA
			 <COND (<EQUAL? ,PRSO ,GLOBAL-VERONICA> ,CORPSE)
			       (T ,PRSO)>
			 <COND (<EQUAL? ,PRSI ,GLOBAL-VERONICA> ,CORPSE)
			       (T ,PRSI)>>
		<RTRUE>)
	       (ELSE
		<GLOBAL-PERSON-F>)>>

<OBJECT VERONICA
	(IN BALLROOM-8)
	(DESC "Veronica")
	(SDESC "fairy queen")
	(SYNONYM VERONICA TITANIA QUEEN ASHCROFT ;WELLMAN)
	(ADJECTIVE VERONICA MRS MS FAIRY WIFE)
	(ACTION VERONICA-F)
	(DESCFCN VERONICA-DESC-F)
	(GENERIC GENERIC-VERONICA-F)
	(FLAGS TRANSBIT PERSON FEMALE THE)
	(CHARACTER 2)>

<ROUTINE GENERIC-VERONICA-F (NAM)
	 <COND (<NOT <EQUAL? .NAM ,W?COSTUME>> ,VERONICA)
	       (ELSE <GENERIC-STUFF-F .NAM>)>>

<ROUTINE VERONICA-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL "Titania, Queen of Faery,">
	 <COND (<VERONICA-UNMASKED?>
		<TELL " in the person of " 'VERONICA ",">)>
	 <TELL " is">
	 <TELL-HERE>>

<ROUTINE TELL-IGNORES () <TELL "She" ,IGNORES-YOU "." CR>>

<GLOBAL IGNORES-YOU " ignores you">

<ROUTINE LONG-MASK-DESC ()
	 <TELL
" It covers the entire head with a glittery silver stocking. The hair is
silver and gold wire streaming out behind as though blown by the wind.
The ears are silvered butterfly wings, and the eyebrows turn up into
antennae." CR>>

<ROUTINE VERONICA-F ()
	 <COND (<EQUAL? ,WINNER ,VERONICA>
		<COND (<VERB? WHAT>
		       <COND (<EQUAL? ,PRSO ,YOU>
			      <TELL
"\"I'm Queen of Faery, stupid!\" she growls." CR>)>)
		      (<VERB? HELLO>
		       <TELL "She pauses for a moment and greets you." CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL-IGNORES>)>)
	       (<VERB? $CALL WAIT>
		<TELL-IGNORES>)
	       (<VERB? EXAMINE>
		<COND (<VERONICA-UNMASKED?>
		       <TELL 'VERONICA " Ashcroft">)
		      (ELSE <TELL "Titania, Queen of Faery">)>
		<TELL " is in her early thirties, about 5'3\" in height,
weighing about 100 pounds. She is wearing a voluminous white gown and
silvered fairy wings. Her mask is quite striking.">
		<LONG-MASK-DESC>)
	       (<VERB? UNMASK ATTACK KILL TAKE CUT>
		<TELL
"\"Stop that! " 'MICHAEL ", help me!\"">
		<COND (<IN? ,MICHAEL ,HERE>
		       <TELL " " 'MICHAEL " restrains you, a quizzical look in
his eye.">)>
		<CRLF>)
	       (<VERB? HELP RUB BRUSH>
		<TELL
"She fends you off, angrily. \"I don't need any help from you!\"" CR>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,VERONICA>>
		<TELL-IGNORES>)
	       (<VERB? DANCE>
		<TELL
"\"Some other time.\" You get the impression this will be soon after the
first ski resort opens in the infernal regions." CR>)>>

<ROUTINE G-VERONICA (GARG)
	 <COND (<NOT .GARG> <IMOVEMENT ,VERONICA G-VERONICA>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<IN? ,VERONICA ,OFFICE>
		       <SETG YELL-TIME
			     <+ <- ,PRESENT-TIME
				   <MOD ,PRESENT-TIME 5>>
				5>>
		       <ENABLE <QUEUE I-ALICIA-SNEAKS 2>>
		       <MOVE ,FAIRY-COSTUME ,CORPSE>
		       <MOVE ,FAIRY-MASK ,OFFICE>
		       <FCLEAR ,FAIRY-MASK ,NDESCBIT>
		       <MOVE ,STAIN ,CORPSE>
		       <MOVE ,HAIR ,FAIRY-MASK>
		       <REMOVE ,VERONICA>
		       <FSET ,VERONICA ,NDESCBIT>
		       <RFALSE>)>)>>

<GLOBAL YELL-TIME <>>

<OBJECT CORPSE
	(IN OFFICE)
	(DESC "Veronica's body")
	(SYNONYM CORPSE BODY VERONICA TITANIA)
	(ADJECTIVE MS MRS FAIRY QUEEN WIFE ASHCROFT VERONICA ;"9/17")
	(DESCFCN CORPSE-DESC-F)
	(ACTION CORPSE-F)
	(GENERIC GENERIC-VERONICA-F)
	(FLAGS INVISIBLE SEARCHBIT TAKEBIT TRANSBIT CONTBIT SURFACEBIT
	       PERSON OPENBIT FEMALE TOLD)
	(CAPACITY 30)
	(SIZE 70)>

<ROUTINE CORPSE-DESC-F ("OPTIONAL" (RARG <>))
	 %<DEBUG-CODE
		  <COND (<AND ,GOSSIP <NOT <FSET? ,WINNER ,TOLD>>>
			 <TELL "[Corpse: " CD ,WINNER " sees it.]" CR>)>>
	 <FSET ,WINNER ,TOLD>
	 <COND (<NOT <FSET? ,CORPSE ,TOUCHBIT>>
		<TELL
"Slumped behind " THE ,LARGE-DESK " is the body of " 'VERONICA " Ashcroft.">
		<COND (<NOT <IN? ,FAIRY-MASK ,CORPSE>>
		       <TELL " Her
mask has been pulled off, though the rest of the costume is intact.">)>
		<COND (<FSET? ,ROPE ,NDESCBIT>
		       <REMOVE ,NOT-ROPE>
		       <TELL
" Around her neck is the agent of death, a rope. In fact, it's your lariat,
which you got tired of carrying around and hung in the closet with your
coat.">)>
		<CRLF>)
	       (ELSE
		<TELL
"Lying in a heap is the body of " 'VERONICA " Ashcroft, strangled">
		<COND (<FSET? ,ROPE ,NDESCBIT>
		       <REMOVE ,NOT-ROPE>
		       <TELL " with a cowboy's lariat">)>
		<TELL "." CR>)>>

<ROUTINE TALKING-TO? (PER)
	 <COND (<VERB? SHOW REVEAL $REVEAL>
		<COND (<EQUAL? ,PRSI .PER> <RTRUE>)>)
	       (<VERB? $CALL ASK-ABOUT ASK-FOR TELL-ME HELLO>
		<COND (<EQUAL? ,PRSO .PER> <RTRUE>)>)>>

<GLOBAL STOPS-YOU " stops you from tampering with evidence.">

<ROUTINE CORPSE-F ()
	 <COND (<OR <EQUAL? ,WINNER ,CORPSE>
		    <AND <VERB? TELL>
			 <EQUAL? ,PRSO ,CORPSE>>>
		<SETG P-CONT <>>
		<SETG QUOTE-FLAG <>>
		<TELL
"At this point, it would take a seance." CR>)
	       (<TALKING-TO? ,CORPSE>
		<TELL
"For obvious reasons, there is no response." CR>)
	       (<AND <VERB? SHOW>
		     <EQUAL? ,PRSO ,CORPSE>
		     <FSET? ,PRSI ,PERSON>
		     <NOT <EQUAL? ,PRSI ,PLAYER>>>
		<REVEAL-MURDER ,PRSI>
		<TELL
CD ,PRSI " recoils in horror. \"No!" ,CALLING-POLICE " " HE/SHE ,PRSI
" says." CR>)
	       (<VERB? DANCE>
		<TELL
,HAVE-TO "lead, you can be sure of that." CR>)
	       (<VERB? EXAMINE>
		<TELL
'VERONICA " is still wearing her costume, stained with whatever she was
drinking."> <COND (<NOT <IN? ,FAIRY-MASK ,CORPSE>>
		   <TELL " Her mask has been removed.">)>
	    <TELL " She was obviously strangled">
	    <COND (<IN? ,CORPSE ,OFFICE>
		   <TELL ", but
there are few signs of a struggle">)>
	   <TELL "." CR>)
	       (<VERB? HELP BRUSH ALARM>
		<TELL
"It's too late to help " 'VERONICA " now." CR>)
	       (<VERB? LISTEN>
		<TELL
,THERE-IS "no sign of breathing." CR>)
	       (<VERB? RUB>
		<TELL "The body is ">
		<COND (<L? ,PRESENT-TIME 570>
		       <TELL "still warm." CR>)
		      (<L? ,PRESENT-TIME 630>
		       <TELL "cooling off." CR>)
		      (ELSE
		       <TELL "cold." CR>)>)
	       (<VERB? LOOK-UNDER RAISE SEARCH>
		<COND (<IN? ,BULLET ,CORPSE>
		       <FCLEAR ,BULLET ,INVISIBLE>
		       <MOVE ,BULLET ,HERE>
		       <TELL
"As you look under the body, you notice a small object on the floor
beneath it." CR>)
		      (<VERB? SEARCH>
		       <TELL
"A search reveals nothing beyond what was first apparent." CR>)>)
	       (<AND <VERB? TAKE MOVE> <EQUAL? ,PRSO ,CORPSE>>
		<COND (<IN? ,DETECTIVE ,HERE>
		       <TELL
CTHE ,DETECTIVE ,STOPS-YOU CR>)
		      (<IN? ,DUFFY ,HERE>
		       <TELL
'DUFFY ,STOPS-YOU CR>)
		      (<OR <VERB? MOVE>
			   <EQUAL? <ITAKE> ,M-HANDLED>>
		       <COND (<VERB? MOVE>
			      <TELL "Moved">)
			     (T
			      <SETG PLAYER-MOVED-BODY? T>
			      <TELL "Taken">)>
		       <TELL
", but the body is heavy.">
		       <FCLEAR ,ROPE ,NDESCBIT>
		       <COND (<IN? ,BULLET ,CORPSE>
			      <FCLEAR ,BULLET ,INVISIBLE>
			      <MOVE ,BULLET ,HERE>
			      <TELL
" As you move the body a small object drops to the floor beneath it.">)>
		       <CRLF>)>
		<RTRUE>)
	       (<VERB? DROP>
		<MOVE ,PRSO ,HERE>
		<TELL "The body drops like a sack of potatoes." CR>)
	       (<VERB? POUR-ON THROW MUNG>
		<TELL "That might destroy evidence." CR>)
	       (<AND <VERB? SLAP KILL ATTACK TIE-WITH TIE-TO>
		     <EQUAL? ,PRSO ,CORPSE>>
		<TELL
"She's quite dead already, you know." CR>)
	       (<AND <VERB? THROW-AT> <EQUAL? ,PRSI ,CORPSE>>
		<MOVE ,PRSO ,HERE>
		<TELL "That wasn't very sporting." CR>)
	       (<AND <VERB? WALK-TO> <NOT <FSET? ,WINNER ,TOLD>>>
		<TELL "What corpse?" CR>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,CORPSE>
		     <NOT <EQUAL? ,PRSO ,FAIRY-MASK>>>
		<TELL-WONT-FIT>)>>

<ROUTINE TELL-WONT-FIT ()
	 <TELL "It won't fit." CR>>

<OBJECT BULLET
	(IN CORPSE)
	(DESC "silver bullet")
	(SYNONYM BULLET OBJECT)
	(ADJECTIVE SILVER SMALL)
	(ACTION BULLET-F)
	(FLAGS INVISIBLE TAKEBIT TRYTAKEBIT)>

<GLOBAL IN-GUNBELT " in your gunbelt.">

<ROUTINE BULLET-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "It looks just like the ones" ,IN-GUNBELT CR>)
	       (<VERB? COUNT>
		<COND (<EQUAL? <META-LOC ,GUNBELT> ,HERE>
		       <COND (<IN? ,BULLET ,GUNBELT>
			      <TELL "All the loops have bullets in them." CR>)
			     (T
			      <TELL
,SEEMS-TO-BE "one empty loop" ,IN-GUNBELT CR>)>)
		      (T <TELL "One." CR>)>)
	       (<AND <VERB? PUT> <EQUAL? ,PRSI ,GUNBELT>>
		<COND (<IN? ,BULLET ,GUNBELT>
		       <TELL "All the bullets are" ,IN-GUNBELT CR>)
		      (T
		       <FSET ,BULLET ,NDESCBIT>
		       <MOVE ,BULLET ,GUNBELT>
		       <TELL
"Okay, each loop of the belt now has a bullet in it." CR>)>)
	       (<VERB? TAKE>
		<COND (<DONT-TAKE-EVIDENCE ,BULLET> <RTRUE>)
		      (<IN? ,BULLET ,GUNBELT>
		       <FCLEAR ,BULLET ,NDESCBIT>)
		      (<EQUAL? ,PRSI ,GUNBELT>
		       <TELL
"Isn't one enough? " ,DO-YOU-WANT-TO "scatter them all over?" CR>
		       <RTRUE>)>
		<FSET ,BULLET ,RMUNGBIT>
		<RFALSE>)
	       (<VERB? BRUSH>
		<FCLEAR ,BULLET ,RMUNGBIT>
		<TELL
"It's now shiny clean again." CR>)>>

<OBJECT FAIRY-COSTUME
	(IN VERONICA)
	(DESC "fairy costume")
	(SYNONYM COSTUME TITANIA)
	(ADJECTIVE FAIRY VERONICA)
	(ACTION FAIRY-COSTUME-F)
	(GENERIC GENERIC-VERONICA-F)
	(FLAGS NDESCBIT ;TAKEBIT ;TRYTAKEBIT)>

<ROUTINE FAIRY-COSTUME-F ("AUX" (DEAD? <IN? ,FAIRY-COSTUME ,CORPSE>))
	 <COND (<VERB? EXAMINE>
		<TELL
"This is a gossamer " 'FAIRY-COSTUME ", intended to represent Titania, Queen of
Faery. It has a silver belt. On the back are fairy wings">
<COND (.DEAD? <TELL ", now crushed">)> <TELL ". The
beauty of the costume is marred by a large red stain on the front." CR>)
	       (<VERB? TAKE>
		<TELL
"Taking the costume would get you into even deeper trouble than you are
in now." CR>)>>

<OBJECT STAIN
	(IN VERONICA)
	(DESC "stain")
	(SYNONYM STAIN)
	(ADJECTIVE RED)
	(ACTION STAIN-F)
	(FLAGS NDESCBIT)
	(SIZE 0)>

<OBJECT STAIN-SAMPLE
	(DESC "cloth sample")
	(SYNONYM CLOTH SAMPLE)
	(FLAGS TAKEBIT BURNBIT)
	(SIZE 1)>

<ROUTINE STAIN-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The large red stain spreads over the front of the costume." CR>)>>

<OBJECT FAIRY-MASK
	(IN VERONICA)
	(DESC "fairy mask")
	(FDESC
"Crumpled on the floor is the fairy costume's mask.")
	(SYNONYM MASK)
	(ADJECTIVE FAIRY)
	(ACTION FAIRY-MASK-F)
	(FLAGS NDESCBIT TRYTAKEBIT TAKEBIT BURNBIT CONTBIT OPENBIT)
	(CAPACITY 10)
	(SIZE 5)>

<ROUTINE FAIRY-MASK-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"This is a very ornate and beautiful mask.">
		<LONG-MASK-DESC>)
	       (<AND <IN? ,FAIRY-MASK ,VERONICA>
		     <VERB? TAKE LOOK-INSIDE LOOK-UNDER RUB LOOK-BEHIND MOVE>>
		<TELL
"As you reach for the mask, " 'VERONICA " pulls back, surprised.">
		<COND (<IN? ,MICHAEL ,HERE>
		       <TELL
" " 'MICHAEL " knocks your hand away. \"What do you think you're doing?\"
he says angrily. \"Are you trying to hurt my wife?\"">)>
		<CRLF>)
	       (<VERB? TAKE> <FCLEAR ,FAIRY-MASK ,WEARBIT> <RFALSE>)
	       (<AND <VERB? PUT> <EQUAL? ,PRSI ,CORPSE>>
		<MOVE ,FAIRY-MASK ,CORPSE>
		<FSET ,FAIRY-MASK ,WEARBIT>
		<TELL "Okay, the mask is on the body." CR>)
	       (<OR <VERB? LOOK-INSIDE SEARCH>
		    <AND <VERB? SEARCH-OBJECT-FOR>
			 <EQUAL? ,PRSO ,FAIRY-MASK>>>
		<COND (<IN? ,FAIRY-MASK ,WINNER>
		       <TELL
"The inside of the mask is slightly damp with sweat.">
		       <COND (<AND <IN? ,HAIR ,FAIRY-MASK>
				   <NOT <FSET? ,HAIR ,TOUCHBIT>>>
			      <FCLEAR ,HAIR ,INVISIBLE>
			      <TELL
" Caught in the silver mesh is " A ,HAIR>
			      <PRINT-CONTENTS ,FAIRY-MASK
					      ". There is also "
					      ,HAIR>
			      <TELL ".">)
			     (<PRINT-CONTENTS ,FAIRY-MASK
					      " The mask contains ">
			      <TELL ".">)>
		       <CRLF>)
		      (ELSE <TELL ,YOU-DONT-HAVE "it." CR>)>)>>

<OBJECT HAIR
	(IN FAIRY-MASK)
	(DESC "dark hair")
	(SYNONYM HAIR)
	(ADJECTIVE DARK)
	(ACTION HAIR-F)
	(FLAGS TAKEBIT BURNBIT INVISIBLE)
	(SIZE 1)>

<ROUTINE HAIR-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The hair is dark and medium in length." CR>)
	       (<VERB? COMPARE>
		<COND (<EQUAL? ,VERONICA-HAIR ,PRSO ,PRSI>
		       <THEY-ARENT "even the same color">)
		      (<EQUAL? ,ALICIA-HAIR ,PRSO ,PRSI>
		       <TELL
"The hairs look very similar in both color and length." CR>)
		      (<EQUAL? ,LINDA-HAIR ,PRSO ,PRSI>
		       <TELL
"They don't resemble each other at all." CR>)>)>>

<OBJECT VERONICA-HAIR
	(IN CORPSE)
	(DESC "Veronica's hair")
	(SYNONYM HAIR)
	(ADJECTIVE VERONICA)
	(ACTION VERONICA-HAIR-F)
	(FLAGS NDESCBIT FEMALE ;"means never use 'the'")
	(SIZE 0)>

<ROUTINE VERONICA-HAIR-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
'PRSO " is short and blonde." CR>)>>

<OBJECT ALICIA-HAIR
	(IN ALICIA)
	(DESC "Alicia's hair")
	(SYNONYM HAIR)
	(ADJECTIVE ALICIA)
	(ACTION ALICIA-HAIR-F)
	(FLAGS NDESCBIT FEMALE ;"means never use 'the'")>

<ROUTINE ALICIA-HAIR-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
'ALICIA-HAIR " is medium length and dark." CR>)
	       (<VERB? MOVE>
		<TELL
'ALICIA " fends you off. \"Are you crazy?\"" CR>)>>

<OBJECT LINDA-HAIR
	(IN LINDA)
	(DESC "Linda's hair")
	(SYNONYM HAIR)
	(ADJECTIVE LINDA)
	(ACTION LINDA-HAIR-F)
	(FLAGS NDESCBIT FEMALE ;"means never use 'the'")>

<ROUTINE LINDA-HAIR-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"Linda's hair is long and red." CR>)
	       (<VERB? MOVE>
		<TELL
"Linda pushes you away. \"Ouch!\"" CR>)>>

<OBJECT PULSE
	(IN CORPSE)
	(DESC "vital signs")
	(SYNONYM PULSE BREATH SIGNS)
	(ADJECTIVE VITAL)
	(ACTION PULSE-F)
	(FLAGS NDESCBIT)
	(SIZE 0)>

<ROUTINE PULSE-F ()
	 <COND (<NOT <EQUAL? <META-LOC ,CORPSE> ,HERE>>
		<NOT-HERE ,PULSE>)
	       (<VERB? TAKE ANALYZE RUB FIND>
		<TELL ,THERE-IS "no sign of life in the corpse." CR>)
	       (<VERB? PUT> <TELL-YOU-CANT "take that">)
	       (<VERB? LISTEN>
		<TELL "You hear nothing." CR>)>>

<ROUTINE REVEAL-MURDER (WHO "AUX" N X (NEWS? <NOT <FSET? .WHO ,TOLD>>))
	 <COND (.NEWS?
		<FSET .WHO ,TOLD>
		%<DEBUG-CODE
		  <COND (,GOSSIP
			 <TELL
"[" CD .WHO " revealed in " D <LOC .WHO> ".]" CR>)>>)>
	 <SET X <FIRST? <LOC .WHO>>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <FSET? .X ,PERSON>
			     <NOT <FSET? .X ,TOLD>>>
			%<DEBUG-CODE
			  <COND (,GOSSIP
				 <TELL
"[" CD .X " overhears in " D <LOC .X> ".]" CR>)>>
			<FSET .X ,TOLD>)>
		 <SET X .N>>
	 <COND (<NOT ,MURDER-PUBLIC?>
		<SETG MURDER-PUBLIC? .WHO>
		%<DEBUG-CODE
		   <COND (,GOSSIP
			  <TELL "[" D ,MURDER-PUBLIC? " called police.]" CR>)>>
		<FSET ,DETECTIVE ,TOLD>
		<FSET ,DUFFY ,TOLD>
		<ENABLE <QUEUE I-POLICE-ARRIVE 25>>)>
	 <RETURN .NEWS?>>

<OBJECT POLICE
	(IN GLOBAL-OBJECTS)
	(DESC "police")
	(SYNONYM POLICE COPS)
	(ADJECTIVE STATE COUNTY)
	(ACTION POLICE-F)
	(FLAGS PERSON NDESCBIT)>

<ROUTINE POLICE-F ("AUX" WHO)
	 <COND (<VERB? PHONE>
		<COND (<NOT <GLOBAL-IN? ,TELEPHONE ,HERE>>
		       <TELL
"If you yell loud enough, perhaps you can overcome the lack of a
telephone." CR>
		       <RTRUE>)>
		<TELL "A bored desk sergeant answers the telephone. ">
		<COND (,MURDER-PUBLIC?
		       <TELL
"You describe the situation,
but he says, \"Hey, we're sending someone over, in fact, two of our best
officers are on the case.\"" CR>)
		      (<NOT <FSET? ,OFFICE ,TOUCHBIT>>
		       <TELL
"After a few minutes of listening
to you, he asks angrily if you have anything to report. Not getting a
reasonable answer to that poser, he hangs up." CR>)
		      (ELSE
		       <REVEAL-MURDER ,PLAYER>
		       <TELL
"He becomes considerably less
bored as you describe the situation. \"Don't let anyone leave,\" he says.
\"There'll be someone there in no time. Don't touch anything!\"" CR>)>)
	       (<VERB? WAIT-FOR>
		<PERFORM ,V?WAIT-FOR ,DETECTIVE>
		<RTRUE>)
	       (<OR <AND <IN? ,DETECTIVE ,HERE>
			 <SET WHO ,DETECTIVE>>
		    <AND <IN? ,DUFFY ,HERE>
			 <SET WHO ,DUFFY>>>
		<PERFORM ,PRSA
			 <COND (<EQUAL? ,PRSO ,POLICE> .WHO)
			       (ELSE ,PRSO)>
			 <COND (<EQUAL? ,PRSI ,POLICE> .WHO)
			       (ELSE ,PRSI)>>
		<RTRUE>)
	       (<AND <VERB? ASK-ABOUT TELL-ME>
		     <EQUAL? ,PRSI ,POLICE>>
		<RFALSE>)
	       (<VERB? FIND>
		<TELL
"You never can find a policeman when you want one, can you?" CR>)
	       (ELSE
		<COND (<VERB? TELL>
		       <SETG P-CONT <>>
		       <SETG QUOTE-FLAG <>>)>
		<TELL ,HAVE-TO "find one first." CR>)>>

\

<OBJECT GLOBAL-ALICIA
	(IN GLOBAL-OBJECTS)
	(DESC "Alicia")
	(SYNONYM GIRL BARRON ALICIA)
	(ADJECTIVE ALICIA HAREM MS MISS)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT CONTBIT PERSON FEMALE)
	(CHARACTER 3)>

<OBJECT ALICIA
	(DESC "Alicia")
	(SYNONYM GIRL BARRON ALICIA)
	(ADJECTIVE ALICIA HAREM MS MISS)
	(ACTION ALICIA-F)
	(DESCFCN ALICIA-DESC-F)
	(FLAGS TRANSBIT CONTBIT PERSON FEMALE)
	(CHARACTER 3)>

<GLOBAL ALICIA-SEEN 0>

<ROUTINE ALICIA-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL 'ALICIA ", ">
	 <COND (<IN? ,ALICIA-COAT ,ALICIA>
		<TELL "wearing a wet overcoat">)
	       (ELSE
		<TELL "dressed in harem silks">)>
	 <TELL ", is">
	 <TELL-HERE>>

<OBJECT ALICIA-COAT
	(IN ALICIA)
	(DESC "wet overcoat")
	(SYNONYM OVERCOAT COAT)
	(ADJECTIVE ALICIA WET)
	(ACTION ALICIA-COAT-F)
	(FLAGS TAKEBIT BURNBIT NDESCBIT CONTBIT
	       TRYTAKEBIT OPENBIT SEARCHBIT ALICIABIT)>

<OBJECT LABEL
	(IN ALICIA-COAT)
	(DESC "label")
	(SYNONYM LABEL)
	(ACTION ALICIA-COAT-F)
	(FLAGS INVISIBLE READBIT)
	(TEXT
"In the coat is a label which reads \"Lord and Taylor\" and underneath
that in sewn script, \"Alicia Barron.\"")>

<ROUTINE ALICIA-COAT-F ()
	 <COND (<VERB? LOOK-INSIDE LOOK-UNDER EXAMINE TAKE TAKE-OFF READ>
		<COND (<IN? ,ALICIA-COAT ,ALICIA>
		       <COND (<NOT <VERB? EXAMINE>>
			      <TELL
'ALICIA " draws the coat more tightly around herself. \"Just what do you
think you're doing?\" she asks, frostily." CR>)
			     (ELSE
			      <TELL
"It's a wet overcoat." CR>)>)
		      (<IN? ,ALICIA-COAT ,BUTLER>
		       <TELL "The butler has the coat now." CR>)
		      (<NOT <VERB? TAKE TAKE-OFF>>
		       <FCLEAR ,LABEL ,INVISIBLE>
		       <TELL <GETP ,LABEL ,P?TEXT> CR>)>)
	       (<VERB? SMELL>
		<TELL
"It smells wet." CR>)
	       (<VERB? RUB>
		<TELL
"It feels wet." CR>)
	       (<VERB? THROUGH WEAR>
		<IT-DOESNT-FIT>)>>

<ROUTINE ALICIA-F ("AUX" (HADBIT? <>))
	 <COND (<EQUAL? ,WINNER ,ALICIA>
		<COND (<VERB? HELLO>
		       <TELL
"\"Hello. " ,YOU-MUST "be the reporter " 'VERONICA " said was coming tonight.\"" CR>)
		      (<AND <VERB? GIVE>
			    <EQUAL? ,PRSO ,ALICIA-COAT>
			    <EQUAL? ,PRSI ,BUTLER>>
		       <MOVE ,ALICIA-COAT ,BUTLER>
		       <FCLEAR ,ALICIA-COAT ,NDESCBIT>
		       <COND (<EQUAL? ,HERE <LOC ,ALICIA>>
			      <TELL
'ALICIA " gives " 'BUTLER " her coat, which is soaking wet. Underneath
she is wearing a harem girl costume which leaves little to the imagination."
CR>)>
		       <RTRUE>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
"\"I beg your pardon?\" she replies." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
'ALICIA " Barron, a dark-haired young woman about 5'2\" tall, is dressed ">
		<COND (<IN? ,ALICIA-COAT ,ALICIA>
		       <TELL
"in a soaking wet overcoat. ">
		       <TELL-YOU-CANT "tell what costume she may be wearing
underneath">)
		      (ELSE
		       <TELL "as
a harem girl. She is a slender, attractive woman. The costume is a
revealing one, and she seems to be pleased with the results." CR>)>)
	       (<AND <VERB? $REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<REVEAL-MURDER ,ALICIA>
		<COND (<IN? ,PRSI ,HERE>
		       <SOMEONE-TELLS-ALICIA T>)
		      (<NEARBY? ,ALICIA>
		       <SOMEONE-TELLS-ALICIA <>>)>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,ALICIA>
		       <ALICIA-HORRIFIED>)
		      (T
		       <TELL "\"Yes, I know, isn't it horrible?\"" CR>)>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,ALICIA>>
		<COND (<NOT <FSET? ,PRSI ,PERSON>>
		       <COND (<EQUAL? ,PRSI ,GLOBAL-MURDER>
			      <COND (<FSET? ,PRSO ,TOLD>
				     <ALICIA-HORRIFIED>)
				    (T
				     <TELL
"\"What murder do you mean?\"" CR>)>)
			     (<EQUAL? ,PRSI ,ALICIA-COAT>
			      <TELL
"\"What about it? It's just my wet overcoat.\"" CR>)
			     (<EQUAL? ,PRSI ,ALICIA-CAR>
			      <TELL
"\"I parked it on the other side of the barn, out of the way of all
the other cars.\"" CR>)
			     (<EQUAL? ,PRSI ,HAIR>
			      <COND (<EQUAL? <META-LOC ,HAIR> ,HERE>
				     <TELL
"She examines the hair carefully. \"It doesn't look like one of mine to
me,\" she says. She doesn't sound terribly convincing." CR>)
				    (ELSE
				     <TELL
,I-DONT-KNOW "what you mean.\"" CR>)>)
			     (<EQUAL? ,PRSI ,HORSE>
			      <TELL
"\"I'm not the rider that some here are: " 'VERONICA " "
<COND (<FSET? ,ALICIA ,TOLD> "was") (T "has been")> " a dressage
champion several times. I like riding to hounds though. Except at the
end when the dogs get the fox. I can't stand the sight of blood.\"" CR>)
			     (ELSE
			      <I-DONT-KNOW-ABOUT "that">)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"" 'VERONICA " mentioned you to me a week or two ago, and I suggested she
invite you. She remembers you fondly from school.\"" CR>)
		      (<EQUAL? ,PRSI ,ALICIA ,GLOBAL-ALICIA>
		       <TELL
"\"There's not much to say. I've had a pretty dull life, not anything
that would interest your readers.\"" CR>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
"\"I have nothing but good things to say about " HIM/HER ,PRSI ".\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <COND (<NOT <FSET? ,PRSO ,TOLD>>
			      <TELL
"\"" 'MICHAEL " is a fine man. I wish I could say that " 'VERONICA " treats him
as well as he deserves.\"" CR>)
			     (ELSE
			      <TELL
"\"Now he's free of that creature! It serves her right.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA>
		       <COND (<NOT <FSET? ,PRSO ,TOLD>>
			      <TELL
"\"" 'VERONICA " and I went to school together. I probably know her as
well as anyone. She has her faults. Of course, I suppose
we all do.\"" CR>)
			     (ELSE
			      <TELL
"\"She was too hard a woman. She must have just pushed someone too hard.
I knew it would happen eventually.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
"\"Poor Richard. He's such a wimp where " 'VERONICA " is concerned.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"A silly old fool, if you ask me. He has that sinecure job with the
trust. I doubt he's had an original thought in his life.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"Isn't she something? I never thought I'd see an Ashcroft hanging around
with the likes of her. Richard acts like he's thirteen years old sometimes,
especially where women are concerned.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"I'll vote for him any time. He's so handsome!\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
"\"What an oaf! I can't imagine why he's here, unless it's to make trouble
of some kind.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <TELL
"\"A courtly gentleman, isn't he? That black cape makes him look almost
cuddly.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"" 'BUTLER " is so silly in that gorilla suit, and he keeps trying to look
dignified. Perhaps I should find him some bananas to carry around.\" She
giggles." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
"\"" 'VERONICA " hired him for tonight.\"" CR>)
		      (ELSE
		       <TELL
"\"I have no opinion.\"" CR>)>)
	       (<VERB? SHOW>
		<COND (<FSET? ,PRSO ,ALICIABIT>
		       <SET HADBIT? T>
		       <FCLEAR ,PRSO ,ALICIABIT>
		       <SETG ALICIA-SEEN <+ ,ALICIA-SEEN 1>>
		       <ENABLE <QUEUE I-FLEE 10>>)>
		<COND (<EQUAL? ,PRSO ,MASK>
		       <TELL
"\"That looks like " 'VERONICA "'s mask.\"" CR>)
		      (<AND <EQUAL? ,PRSO ,HAIR>
			    <IN? ,HAIR ,FAIRY-MASK>>
		       <TELL
"\"I don't see what this has to do with me. " 'VERONICA " probably
dyed her hair. I wouldn't put it past her.\"" CR>)
		      (<EQUAL? ,PRSO ,HAIR>
		       <TELL
"\"Why are you showing me this? It's just a hair.\"" CR>)
		      (<EQUAL? ,PRSO ,HAIR-ANALYSIS>
		       <TELL
"\"That's silly! You think it's my hair? Millions of women have dark
hair! You know those costume places, they don't really clean the costumes
very well, the hair's probably been there for months.\"" CR>)
		      (<EQUAL? ,PRSO ,CORPSE>
		       <COND (<REVEAL-MURDER ,ALICIA>
			      <TELL
"It takes Alicia a few moments to recover from the shock. Then, suddenly,
she laughs! \"This is wonderful! Now I can marry " 'MICHAEL "! But why
are you doing this?" ,CALLING-POLICE CR>)
			     (ELSE
			      <TELL
"\"Yes, I know. It's horrible, isn't it?\" She chuckles. \"She was my
friend, but I'm glad she's dead. Now I can marry " 'MICHAEL ".\"" CR>)>)
		      (.HADBIT?
		       <TELL
,I-DONT-KNOW "what you hope to accomplish waving these things in my
face.\"" CR>)>)>>

<ROUTINE ALICIA-HORRIFIED ()
	 <TELL
"\"It's horrible! She was my best friend. Who could have done such
a thing?\"" CR>>

<ROUTINE SOMEONE-TELLS-ALICIA (HERE?)
	 <TELL
CD ,WINNER " tells Alicia " <COND (.HERE? "of the murder") (T "something")>
". It horrifies and then elates her." CR>>

<GLOBAL CALLING-POLICE " I'm calling the police!\"">

<OBJECT ALICIA-CAR
	(IN GLOBAL-OBJECTS)
	(DESC "Alicia's car")
	(SYNONYM CAR)
	(ADJECTIVE ALICIA)
	(FLAGS NDESCBIT)>

<GLOBAL FLEEING? <>>

<ROUTINE I-FLEE ()
	 <COND (<G? ,ALICIA-SEEN 2>
		<SETG FLEEING? T>
		<ESTABLISH-GOAL ,ALICIA ,SITTING-ROOM T>)>
	 <COND (<G? ,MICHAEL-SEEN 1>
		<SETG FLEEING? T>
		<ESTABLISH-GOAL ,MICHAEL ,SITTING-ROOM T>)>
	 <RFALSE>>

<OBJECT NOT-ROPE
	(IN PLAYER)
	(DESC "lariat (no, you left it with your coat)")
	(SYNONYM LARIAT LASSO ROPE)
	(ACTION NOT-ROPE-F)
	(FLAGS NDESCBIT TRYTAKEBIT TAKEBIT)>

<ROUTINE NOT-ROPE-F ()
	 <REMOVE ,NOT-ROPE>
	 <TELL
"Remember, the silly thing was getting in your way, particularly when you
danced, so you went back and hung it in the closet with your coat.">
	 <COND (<EQUAL? ,HERE ,EAST-COAT-CLOSET>
		<TELL
" But it doesn't seem to be here now.">)>

	 <CRLF>>

<OBJECT ROPE
	(IN OFFICE)
	(DESC "lariat")
	(SYNONYM LARIAT LASSO ROPE)
	(ACTION ROPE-F)
	(FLAGS NDESCBIT TRYTAKEBIT TAKEBIT BURNBIT WEAPONBIT)>

<ROUTINE ROPE-F ()
	 <REMOVE ,NOT-ROPE>
	 <COND (<VERB? EXAMINE>
		<TELL
"It's a fairly thin rope, like the sort of rope movie cowboys carry. It
looks serviceable, though." CR>)
	       (<VERB? TAKE>
		<COND (<DONT-TAKE-EVIDENCE ,ROPE> <RTRUE>)
		      (T
		       <FCLEAR ,ROPE ,NDESCBIT>
		       <RFALSE>)>)>>

<ROUTINE DONT-TAKE-EVIDENCE (OBJ "AUX" WHO)
	 <COND (<IN? ,DETECTIVE ,HERE>
		<SET WHO ,DETECTIVE>)
	       (<IN? ,DUFFY ,HERE>
		<SET WHO ,DUFFY>)
	       (ELSE <RFALSE>)>
	 <TELL CD .WHO " stops you. \"That " D .OBJ " is evidence. Don't
take it!\"" CR>>

<GLOBAL ALICIA-HERE? <>>

<ROUTINE TELL-ALICIA-ARRIVES ()
	 <TELL "Alicia Barron" ,ARRIVES>>

<GLOBAL ARRIVES " arrives at the ">

<ROUTINE TELL-ARRIVES (WHO)
	 <TELL CD .WHO ,ARRIVES>>

<ROUTINE G-ALICIA (GARG "AUX" (L <LOC ,ALICIA>))
	 <COND (<NOT .GARG> <IMOVEMENT ,ALICIA G-ALICIA>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL
"Alicia seems to be looking for any excuse to leave you." CR>)
	       (<EQUAL? .GARG ,G-ENROUTE>
		<COND (<AND <EQUAL? .L ,HALLWAY-12>
			    <IN? ,ALICIA-COAT ,ALICIA>>
		       <FCLEAR ,ALICIA-COAT ,NDESCBIT>
		       <MOVE ,ALICIA-COAT ,EAST-COAT-CLOSET>
		       <COND (<OR <CORRIDOR-LOOK ,ALICIA>
				  <EQUAL? ,HERE ,EAST-COAT-CLOSET>>
			      <TELL
'ALICIA " deposits her coat in the coat closet." CR>)>)>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<AND <IN? ,ALICIA ,BALLROOM-5>
			    <IN? ,MICHAEL ,BALLROOM-5>>
		       <SETG ALICIA-HERE? T>
		       <THEY-DANCE ,ALICIA>)
		      (<EQUAL? .L ,PORCH>
		       <SETG NEW-ARRIVAL ,ALICIA>
		       <ESTABLISH-GOAL ,MICHAEL ,BALLROOM-5>
		       <ESTABLISH-GOAL ,BUTLER ,HALL T>
		       <COND (<EQUAL? ,HERE ,PORCH>
			      <TELL-ALICIA-ARRIVES>
			      <TELL
"front porch. Her overcoat is soaking wet.">
			      <COND (<NOT ,PLAYER-HIDING>
				     <TELL
" \"Hi,\" she says. \"Late as usual. I parked back near the barn, there
are so many cars out here I'm afraid someone would dent mine.\"">)>
			      <TELL
" She rings " THE ,DOORBELL "." CR>)
			     (<EQUAL? ,HERE ,CIRCLE>
			      <TELL-ALICIA-ARRIVES>
			      <TELL
'FRONT-DOOR " and rings the bell." CR>)
			     (<NOT <OUTSIDE? ,HERE>>
			      <TELL
CTHE ,DOORBELL " rings." CR>)>)
		      (<AND ,FLEEING? <EQUAL? .L ,SITTING-ROOM>>
		       <UNPRIORITIZE ,ALICIA>
		       <COND (<IN? ,MICHAEL .L>
			      <GOALS? ,MICHAEL T>
			      <ESTABLISH-GOAL ,ALICIA ,BARN T>
			      <ESTABLISH-GOAL ,MICHAEL ,BARN T>)
			     (T
			      <GOALS? ,ALICIA <>>)>
		       <RFALSE>)
		      (<EQUAL? .L ,BARN>
		       <GOALS? ,ALICIA <>>
		       <BARN-DANCE ,ALICIA>)>)>>

<ROUTINE BARN-DANCE (WHO "AUX" (FLG <>))
	 <ENABLE <QUEUE I-ESCAPE 20>>
	 <COND (<FSET? ,BARN-DOOR ,LOCKED>
		<FCLEAR ,BARN-DOOR ,LOCKED>
		<COND (<EQUAL? ,HERE ,WEST-OF-GARAGE>
		       <TELL
'WHO " unlocks the barn door and enters." CR>
		       <SET FLG T>)>)>
	 <OR <I-SCREAMS> .FLG>>

<ROUTINE I-SCREAMS ()
	 <ENABLE <QUEUE I-SCREAMS 1>>
	 <COND (<AND <IN? ,MICHAEL ,BARN>
		     <IN? ,ALICIA ,BARN>
		     <EQUAL? ,HERE
			     ,WEST-OF-HOUSE
			     ,WEST-OF-GARAGE
			     ,NORTH-OF-HOUSE>>
		<TELL
"You hear shouting and screams from the direction of the barn." CR>)>>

<ROUTINE I-ESCAPE ()
	 <REMOVE ,ALICIA>
	 <DISABLE <INT I-SCREAMS>>
	 <COND (<OUTSIDE? ,HERE>
		<TELL
"You hear a car off behind the barn. The sound grows fainter and
fainter." CR>)>>

<ROUTINE I-ALICIA-SNEAKS ()
	 <COND (<AND <NOT <EQUAL? ,HERE ,GARDEN ,WALKWAY ,HALLWAY-7>>
		     <NOT <EQUAL? ,HERE ,NORTH-OF-HOUSE ,HALLWAY-14>>>
		<START-ALICIA ,WALKWAY>)
	       (<AND <NOT <EQUAL? ,HERE
				  ,HALLWAY-4 ,HALLWAY-3 ,HALLWAY-2>>
		     <NOT <EQUAL? ,HERE
				  ,HALLWAY-1 ,WEST-OF-GARAGE>>>
		<COND (,ALICIA-WAITED?
		       <START-ALICIA ,WEST-OF-GARAGE>)
		      (ELSE
		       <SETG ALICIA-WAITED? T>
		       <QUEUE I-ALICIA-SNEAKS 3>)>)>
	 <RFALSE>>

<GLOBAL ALICIA-WAITED? <>>

<ROUTINE START-ALICIA (RM)
	 <DISABLE <INT I-ALICIA-SNEAKS>>
	 <MOVE ,ALICIA .RM>
	 <ESTABLISH-GOAL ,ALICIA ,PORCH>
	 <FCLEAR ,CORPSE ,INVISIBLE>
	 <FSET ,NORTH-DOOR ,LOCKED>
	 <FSET ,WEST-DOOR ,LOCKED>
	 <FCLEAR ,NORTH-OFFICE-DOOR ,LOCKED>
	 <FCLEAR ,SOUTH-OFFICE-DOOR ,LOCKED>
	 <FCLEAR ,MEDIA-OFFICE-DOOR ,LOCKED>
	 <FCLEAR ,NORTH-OFFICE-DOOR ,OPENBIT>
	 <FCLEAR ,SOUTH-OFFICE-DOOR ,OPENBIT>
	 <FCLEAR ,MEDIA-OFFICE-DOOR ,OPENBIT>>

<ROUTINE THEY-DANCE (LAST "AUX" FIRST)
	 <ENABLE <QUEUE I-MICHAEL-TO-GARAGE 5>>
	 <NEW-SCRIPT ,MICHAEL ,MICHAEL-LOOP>
	 <COND (<IN-BALLROOM? ,PLAYER>
		<COND (<EQUAL? .LAST ,MICHAEL> <SET FIRST ,ALICIA>)
		      (ELSE <SET FIRST ,MICHAEL>)>
		<TELL
D .LAST " walks up to " D .FIRST " and they begin to dance." CR>)>>

<ROUTINE I-MICHAEL-TO-GARAGE ()
	 <COND (,MICHAEL-TO-GARAGE? <RFALSE>)
	       (<AND <OR <FSET? ,MICHAEL ,TOLD>
			 ,GANG-BEEN-TO-OFFICE?>
		     <NOT <EQUAL? <GET <GET ,GOAL-TABLES ,MICHAEL-C>
				       ,GOAL-F>
				  ,OFFICE
				  ,HALLWAY-3>>>
		%<DEBUG-CODE
		  <COND (,DEBUG
			 <TELL "[Michael heads to Garage]" CR>)>>
		<SETG MICHAEL-TO-GARAGE? T>
		<ESTABLISH-GOAL ,ALICIA ,BALLROOM-9>
		<ESTABLISH-GOAL ,MICHAEL ,GARAGE T>)
	       (ELSE
		%<DEBUG-CODE
		  <COND (,DEBUG
			 <TELL "[Michael isn't ready]" CR>)>>
		<ENABLE <QUEUE I-MICHAEL-TO-GARAGE 5>>)>
	 %<DEBUG-CODE <COND (,DEBUG <RTRUE>)>>
	 <RFALSE>>

<GLOBAL MICHAEL-TO-GARAGE? <>>

\

<OBJECT GLOBAL-RICHARD
	(IN GLOBAL-OBJECTS)
	(DESC "Richard")
	(SDESC "Werewolf")
	(SYNONYM ASHCROFT WEREWOLF RICHARD)
	(ADJECTIVE MR RICHARD)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON THE)
	(CHARACTER 4)>

<OBJECT RICHARD
	(IN SITTING-ROOM)
	(SDESC "Werewolf")
	(LDESC "A petulant werewolf slouches nearby.")
	(SYNONYM ASHCROFT WEREWOLF RICHARD)
	(ADJECTIVE MR RICHARD)
	(ACTION RICHARD-F)
	(FLAGS TRANSBIT PERSON THE)
	(CHARACTER 4)>

<GLOBAL RICHARD-SDESC "Richard">

<ROUTINE RICHARD-UNMASKED? ()
	 <EQUAL? <GETP ,RICHARD ,P?SDESC> ,RICHARD-SDESC>>

<ROUTINE RICHARD-UNMASKS ()
	 <FCLEAR ,RICHARD ,THE>
	 <PUTP ,RICHARD ,P?SDESC ,RICHARD-SDESC>
	 <FCLEAR ,GLOBAL-RICHARD ,THE>
	 <PUTP ,GLOBAL-RICHARD ,P?SDESC ,RICHARD-SDESC>
	 <PUTP ,RICHARD ,P?LDESC
"Richard Ashcroft, the petulant werewolf, slouches nearby.">>

<ROUTINE RICHARD-F ()
	 <COND (<EQUAL? ,WINNER ,RICHARD>
		<COND (<OR <VERB? UNMASK>
			   <AND <VERB? WHAT> <EQUAL? ,PRSO ,YOU>>>
		       <COND (<RICHARD-UNMASKED?>
			      <TELL
"\"I'm still Richard.\"" CR>)
			     (<PROB 50>
			      <TELL
"\"None of your business! Grrr!\"" CR>)
			     (ELSE
			      <RICHARD-UNMASKS>
			      <TELL
"He answers somewhat gruffly, \"Oh, I'm Richard under all this fur.\"" CR>)>)
		      (<VERB? HELLO>
		       <TELL
"Richard mumbles a surly greeting." CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
"\"Not on your life!\" he says angrily." CR>)>)
	       (<VERB? EXAMINE>
		<COND (<RICHARD-UNMASKED?>
		       <TELL
"Richard Ashcroft is " 'VERONICA "'s younger brother, and">)
		      (ELSE
		       <TELL "The wearer of the costume">)>
		<TELL" appears as a plump and petulant
werewolf, although he has gone to the trouble of smearing something wet
and red on his chin which looks authentically bloody." CR>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,RICHARD>
		       <TELL
"\"You're joking, of course. No, you're not, are you?\" He seems
shocked, but it's hard to tell if it's just a pose." CR>)
		      (ELSE
		       <TELL
"\"I already know.\"" CR>)>)
	       (<VERB? UNMASK>
		<TELL
"\"Hey, watch it! I'll bite you!\"" CR>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,RICHARD>>
		<COND (<NOT <RICHARD-UNMASKED?>>
		       <COND (<NOT <FSET? ,PRSO ,TOLD>>
			      <TELL "\"Grrr!\"" CR>
			      <RTRUE>)
			     (ELSE
			      <RICHARD-UNMASKS>
			      <TELL
"The werewolf removes his mask, revealing him as Richard, " 'VERONICA "'s
younger brother. ">)>)>
		<COND (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"I've never met you before tonight. You work for the paper,
right?\"" CR>)
		      (<EQUAL? ,PRSI ,RICHARD>
		       <TELL
"\"Me? I'm not interesting enough to write about. Write about my sister
instead, she's interesting: she's the Dragon Lady, not the Fairy Queen.\"" CR>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
"\"Are you trying to cause trouble? " ,YOU-MUST "think I'm drunk and will say
anything about anyone.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <TELL
"\"" 'MICHAEL "? He thinks he's pretty wonderful, but he just slides around
after my sister, taking whatever he can. I don't think he ever loved
her, but then, I don't think anyone ever loved her.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA>
		       <COND (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"You think I did it, don't you? If I was the sort of person
who could kill her, I would have long ago, believe me!\"" CR>)
			     (ELSE
			      <TELL
"\"She's my older sister, but she acts like she's my keeper.
I have to account for my every move, like I was still ten years old.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <TELL
"\"She's such a goodie two-shoes, she's been " 'VERONICA "'s friend for years,
but you know something? Whenever they're apart, she cuts her
up something fierce. I have my suspicions about her.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"That pompous blowhard! He's been in clover for
years, just because he was a crony of my father's. Now he runs the trust
and " 'VERONICA " has him in the palm of her hand! But I'll get mine
one of these days, just wait!\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"Linda's a perfect example of my sister's interference. She's sweet, and
lovely, and I love her, but my sister can't stand her because her family
didn't come over on the Mayflower.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"Our family has known him for years, since he was just on the county
council. I'd think more of him if " 'VERONICA " didn't like him so much.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
,I-DONT-KNOW "why " 'VERONICA " invited him. He's making a fool
of himself. He's going to have trouble from me if he keeps
staring at Linda like that.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <TELL
"\"Who's he? He seems like a nice enough fellow.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"He's been here so long he's part of the furniture.
He taught me to ride when I was a child. " 'VERONICA ", too. Dad was
too busy.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
"\"He's somebody " 'VERONICA " hired.\"" CR>)
		      (ELSE
		       <I-WOULDNT-KNOW>)>)>>

<ROUTINE G-RICHARD (GARG)
	 <COND (<NOT .GARG> <IMOVEMENT ,RICHARD G-RICHARD>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL
CD ,RICHARD " seems to find you more and more boring as time passes." CR>)>>

\

<OBJECT GLOBAL-COL-MARSTON
	(IN GLOBAL-OBJECTS)
	(DESC "Colonel Marston")
	(SYNONYM MARSTON EXPLORER HUNTER ROBERT)
	(ADJECTIVE COLONEL ROBERT)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 5)>

<OBJECT COL-MARSTON
	(IN LIVING-ROOM)
	(DESC "Colonel Marston")
	(LDESC "Colonel Marston, the African Explorer, is here.")
	(SYNONYM MARSTON EXPLORER HUNTER ROBERT)
	(ADJECTIVE COL COLONEL ROBERT)
	(ACTION COL-MARSTON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 5)>

<GLOBAL MARSTON-SEEN-TRUST-DOCUMENTS? <>>

<ROUTINE COL-MARSTON-F ()
	 <COND (<EQUAL? ,WINNER ,COL-MARSTON>
		<COND (<VERB? HELLO>
		       <TELL
"He replies, somewhat curtly." CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL 'COL-MARSTON " only scowls at you." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
'COL-MARSTON " is bedecked as an explorer or perhaps a big-game hunter.
From pith helmet down to whipcord trousers, he looks the part. His
gaze is steely and his white mustache painstakingly trimmed." CR>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,COL-MARSTON>
		       <TELL
"\"Are you sure? I mean, how terrible!\" He seems to have conflicting
feelings about what he has just heard." CR>)
		      (ELSE
		       <TELL
"\"I already know. Only a reporter would be spreading this like it was
some bit of dirty gossip.\"" CR>)>)
	       (<VERB? ACCUSE>
		<COND (<EQUAL? ,PRSI ,GLOBAL-EMBEZZLEMENT>
		       <COND (,MARSTON-SEEN-TRUST-DOCUMENTS?
			      <TELL
"\"You'd have a hard time proving anything, documents or no. At the worst,
they would say I've made some bad investments. Of course, you could try
to ruin me in the press, but I'll sue if you do. You know most libel
suits are found for the plaintiff these days.\"" CR>)
			     (ELSE
			      <TELL
"\"What could you mean by that? I've never stolen anything in my life.
I've never had to.\" He grins." CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-MURDER>
		       <TELL
"\"What a ridiculous accusation!\"" CR>)>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,COL-MARSTON>>
		<COND (<NOT <FSET? ,PRSI ,PERSON>>
		       <COND (<EQUAL? ,PRSI ,GLOBAL-MURDER>
			      <COND (<FSET? ,PRSO ,TOLD>
				     <TELL
"\"Maybe she surprised someone. A sneak thief, probably.\"" CR>)
				    (T
				     <TELL
,I-DONT-KNOW "of any murder.\"" CR>)>)
			     (<EQUAL? ,PRSI ,TRUST ,TRUST-FOLDER
				      ,TRUST-DOCUMENTS>
			      <COND (,MARSTON-SEEN-TRUST-DOCUMENTS?
				     <TELL
"\"What more could I tell you? You'll just write lies anyway!\"" CR>)
				    (ELSE
				     <TELL
"\"I've run the Trust for almost twenty years. I'm proud of what I've done.
Sure, there have been some bad years, but the trend is up.\" He looks
resolved and confident." CR>)>)
			     (ELSE
			      <I-DONT-KNOW-ABOUT "it that would interest you">)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"I don't like reporters very much, if that's what you're getting at.\"" CR>)
		      (<EQUAL? ,PRSI ,COL-MARSTON>
		       <TELL
"\"Well, I'm really semi-retired. I run the Ashcroft Family Trust, but it
mostly runs itself: I don't need to be involved in day-to-day operations
too much. Just a decision now and then.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA ,CORPSE>
		       <COND (,MARSTON-SEEN-TRUST-DOCUMENTS?
			      <TELL
"\"She was conspiring against me! She had some foolish idea that I'm not
running the trust properly. That's what those ridiculous documents are
about! Now she's dead, and it's only just desserts!\" He turns livid with
embarrassment. \"I didn't mean that... I didn't kill her... Don't jump to
conclusions...\"" CR>)
			     (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"'Nil nisi,' they say, but I never liked her very much. Didn't have the
vision a man would have. Home and hearth. Should be a man at the
head of a great old family like the Ashcrofts. Of course, Richard's the
head now, officially.\"" CR>)
			     (ELSE
			      <TELL
"\"I can't say that working with her is as rewarding as working with her father
was, still, I can't really complain.\"" CR>)>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
'COL-MARSTON " glances at " D ,PRSI ", then sniffs disdainfully at you, as though
you had asked him to stand on his head." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <COND (,MARSTON-SEEN-TRUST-DOCUMENTS?
			      <TELL
"\"" 'MICHAEL "? Well, sometimes he makes big promises and doesn't
follow through...  Fundamentally a sound fellow, though.\" "
'COL-MARSTON " seems somewhat distracted." CR>)
			     (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"He must be devastated. But he's a strong man, he'll survive it.\"" CR>)
			     (ELSE
			      <TELL
"\"A fine man. You can count on him. " 'VERONICA "'s father would have approved
of him. He'll get her straightened out one day.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <TELL
"\"She's one of " 'VERONICA "'s cronies. Went to school with her, but then I heard
you did too? Anyway, I hardly know her.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
"\"As Teddy Roosevelt said, 'I could carve a man with more backbone out of a
banana.' The only thing he stands up to " 'VERONICA " on is that Linda person. He's
never really grown up.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"She's just not our sort. I know that sounds prejudiced, but she's not happy
here, you can tell, and she'd be better off if she and Richard stopped seeing
each other. It would be kinder to her.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"A fine Senator. He has plans. You'll hear more from him, mark my
words.\"" CR> )
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
"\"The man is clearly an alcoholic. I don't approve of people who can't hold
their liquor.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <TELL
"\"That's a man with a true eye for business. I wonder why he's here tonight?
" 'VERONICA " and " 'MICHAEL " don't mix too much with his crowd, and vice versa.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"" 'BUTLER " is the disproof of the canard that there are no good servants
anymore.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
"\"He told me he's studying law. Lawyers and accountants! Two
professions we would be better off without! We can always use a good
bartender.\"" CR>)
		      (ELSE
		       <TELL
"\"I have nothing to say about that.\"" CR>)>)
	       (<VERB? SHOW>
		<COND (<EQUAL? ,PRSO ,SALE-FOLDER ,SALE-AGREEMENT>
		       <TELL
'COL-MARSTON " glances cursorily through the agreement. " ,I-DONT-KNOW
"where you got this. It's true, " 'VERONICA " was going to sell the farm and
move further upcountry, away from the suburbs. It wasn't supposed to be
announced until tomorrow." <COND (<FSET? ,COL-MARSTON ,TOLD>
				  " Too bad it was never")
				 (T
				  " Odd that it isn't")>
			   " signed.\" He smiles
frostily." CR>)
		      (<OR <EQUAL? ,PRSO ,TRUST-DOCUMENTS>
			   <AND <EQUAL? ,PRSO ,TRUST-FOLDER>
				<IN? ,TRUST-DOCUMENTS ,TRUST-FOLDER>>>
		       <COND (,MARSTON-SEEN-TRUST-DOCUMENTS?
			      <TELL
"\"I have nothing more to say. I've said too much already. If you publish
anything you'll hear from my lawyer!\"" CR>)
			     (ELSE
			      <SETG MARSTON-SEEN-TRUST-DOCUMENTS? T>
			      <COND (<IN? ,INVESTOR-LIST ,MICHAEL>
				     %<DEBUG-CODE
				       <COND (,DEBUG
					      <TELL
"[Marston scared]" CR>)>>
				     <ESTABLISH-GOAL ,COL-MARSTON ,LIBRARY T>
				     <ESTABLISH-GOAL ,MICHAEL ,LIBRARY T>)>
			      <TELL
"The colonel's composure breaks for a moment, then reforms. \"Where did
you get that? I've run that Trust for twenty years, and all my
investments have been good: for her. I finally decided I should get
something out of it. Do you know what she pays me? Peanuts! And she
wallows in luxury, decadence. I wanted a turn. Besides, I did nothing
wrong, you can't prove anything, no matter what those accountants
say.\"" CR>)>)>)>>

<ROUTINE G-COL-MARSTON (GARG "AUX" (L <LOC ,COL-MARSTON>))
	 <COND (<NOT .GARG> <IMOVEMENT ,COL-MARSTON G-COL-MARSTON>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<COND (<IN? ,COL-MARSTON ,OFFICE>
		       <RFALSE>)
		      (<IN? ,COL-MARSTON ,LIBRARY>
		       <FCLEAR ,LIBRARY-DOOR ,LOCKED>
		       <RFALSE>)>
		<TELL
'COL-MARSTON " looks at his watch, and not very surreptitiously." CR>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<AND <EQUAL? .L ,BALLROOM-9>
			    <ENABLED? <INT I-ARGUMENT>>>
		       <GOALS? ,COL-MARSTON <>>
		       <RFALSE>)
		      (<AND <EQUAL? .L ,HALLWAY-3>
			    <NOT ,THREE-STOOGES-IN-OFFICE?>>
		       <GOALS? ,COL-MARSTON <>>
		       <COND (<AND <IN? ,COCHRANE ,HALLWAY-3>
				   <IN? ,MICHAEL ,HALLWAY-3>>
			      <GANGS-ALL-HERE>)>)
		      (<EQUAL? .L ,OFFICE>
		       <UNPRIORITIZE ,COL-MARSTON>
		       <ESTABLISH-GOAL ,COL-MARSTON ,BALLROOM-9>
		       <GRAB-ATTENTION ,COL-MARSTON>
		       <RFALSE>)
		      (<EQUAL? .L ,LIBRARY>
		       <COND (<IN? ,MICHAEL ,LIBRARY>
			      <LIBRARY-MEETING ,COL-MARSTON>)
			     (ELSE
			      <GOALS? ,COL-MARSTON <>>
			      <RFALSE>)>)
		      (<AND <IN? ,INVESTOR-LIST ,COL-MARSTON>
			    <EQUAL? .L ,BALLROOM-8>>
		       <FCLEAR ,INVESTOR-LIST ,INVISIBLE>
		       <MOVE ,INVESTOR-LIST ,FIREPLACE>
		       <ENABLE <QUEUE I-BURNED 1>>
		       <COND (<EQUAL? ,HERE ,BALLROOM-8>
			      <TELL-ARRIVES ,COL-MARSTON>
			      <TELL
"fireplace, warms his hands briefly, and then
turns to warm his back. As he does, you notice a crumpled piece of paper
drop from his hands into the fireplace. It doesn't land quite in the fire
though. It's beginning to singe a bit." CR>)
			     (<IN-BALLROOM? ,PLAYER>
			      <TELL
'COL-MARSTON " is now warming his hands and back at the fireplace. You
catch an odd movement out of the corner of your eye." CR>)>)>)>>

<GLOBAL LIST-BURNING? <>>

<ROUTINE I-BURNED ()
	 <COND (<IN? ,INVESTOR-LIST ,FIREPLACE>
		<COND (<NOT ,LIST-BURNING?>
		       <SETG LIST-BURNING? T>
		       <QUEUE I-BURNED 1>
		       <COND (<EQUAL? ,HERE ,BALLROOM-8>
			      <TELL
"The piece of paper is beginning to smolder." CR>)>)
		      (ELSE
		       <MOVE ,INVESTOR-LIST ,POLICE-LAB>
		       <COND (<EQUAL? ,HERE ,BALLROOM-8>
			      <TELL
"The crumpled piece of paper bursts into flame and is reduced to ashes." CR>)>)>)>>

\

<OBJECT GLOBAL-LINDA
	(IN GLOBAL-OBJECTS)
	(DESC "Linda")
	(SYNONYM LINDA MEADE BALLERINA)
	(ADJECTIVE LINDA MISS MS)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON FEMALE)
	(CHARACTER 6)>

<OBJECT LINDA
	(IN SITTING-ROOM)
	(DESC "Linda")
	(LDESC "Linda Meade, prima ballerina, is here.")
	(SYNONYM LINDA MEADE BALLERINA)
	(ADJECTIVE LINDA MISS MS)
	(ACTION LINDA-F)
	(FLAGS TRANSBIT PERSON FEMALE)
	(CHARACTER 6)>

<GLOBAL BOOP-CNT 1>

<ROUTINE LINDA-F ()
	 <COND (<EQUAL? ,WINNER ,LINDA>
		<COND (<VERB? HELLO>
		       <TELL "\"Hi! What's your sign?\"" CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL "Linda bats her eyes and looks confused." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"Linda Meade is dressed as a ballerina. Her costume and hair are both
flaming red. She is a beautiful woman, and knows it. Eyes
follow her every move." CR>)
	       (<VERB? UNMASK RUB>
		<TELL
"\"Stop that, silly!\" she giggles." CR>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,LINDA>
		       <TELL
"\"Yuck! I think I don't feel too well.\" She shivers, and then
composes herself. \"Now Richard will be out from under her thumb.\" She
looks at you as though she committed an indiscretion, and then
smiles inanely." CR>)
		      (T
		       <TELL
"\"Everyone will treat it like a juicy piece of gossip! Just wait. She's dead,
poor thing. I didn't like her very much, but honestly!\"" CR>)>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,LINDA>>
		<COND (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"I heard you're a reporter. Will you write about me?\"">)
		      (<EQUAL? ,PRSI ,LINDA>
		       <TELL
"\"Until I met Richard I was working at the drug store, checking people
out. It wasn't very exciting. Now I'm going to be a model! It's my
ambition: I'll be on TV someday!\"">)
		      (<AND <FSET? ,PRSI ,PERSON> <IN? ,PRSI ,HERE>>
		       <TELL
"\"You wouldn't want me to commit a faux pas, would you?\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <TELL
"\"He's nasty to me. I don't think he likes Richard much.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA>
		       <TELL
"\"She hates me. She hates Richard! I hate her! She thinks she's
so great because she's got a lot of money. She treats Richard like a child,
doling out an allowance! Really! He's thirty years old! Just because
she's got control of the Trust! Confidentially, he hates her, too.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <TELL
,I-DONT-KNOW "her.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
"\"We're in love! " 'VERONICA " is keeping us from being married, by
not giving Richard what's coming to him from the Trust. It's not
fair at all!\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"That old monster! He hates Richard! He won't make " 'VERONICA " give
him what's coming to him lawfully. He says he can't change the rules,
but that's silly: doesn't he run it?\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"Isn't it exciting? A real Senator. He's even distinguished dressed in
that silly costume.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
,I-DONT-KNOW "him. He's drunk, isn't he?\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <TELL
"\"He owns that building company. Their signs are all over the
place!\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"He hates me. He kicked me out once when I came
over without Richard.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
,I-DONT-KNOW "him. I don't think he usually works here.\"">)
		      (ELSE
		       <TELL-DONT-KNOW>
		       <RTRUE>)>
		<SETG BOOP-CNT <- ,BOOP-CNT 1>>
		<COND (<EQUAL? ,BOOP-CNT 0>
		       <SETG BOOP-CNT 10>
		       <TELL
" Linda's voice is high and squeaky, a sort of Betty Boop voice.">)>
		<CRLF>)>>

<ROUTINE G-LINDA (GARG)
	 <COND (<NOT .GARG> <IMOVEMENT ,LINDA G-LINDA>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL "Linda seems increasingly impatient with you." CR>)>>

\

<OBJECT GLOBAL-SEN-ASHER
	(IN GLOBAL-OBJECTS)
	(DESC "Senator Asher")
	(SYNONYM ASHER HARLEQUIN ALAN AL)
	(ADJECTIVE SENATOR SEN ALAN AL)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 7)>

<OBJECT SEN-ASHER
	(IN MEDIA-ROOM)
	(DESC "Senator Asher")
	(SYNONYM ASHER HARLEQUIN ALAN AL)
	(ADJECTIVE SENATOR ALAN AL SEN)
	(ACTION SEN-ASHER-F)
	(DESCFCN SEN-ASHER-DESC-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 7)>

<ROUTINE SEN-ASHER-DESC-F ("OPTIONAL" (RARG <>))
	 <COND (<IN? ,SEN-ASHER ,MEDIA-ROOM>
		<TELL
'SEN-ASHER ", dressed in harlequin costume, is relaxing on a sofa,
watching the news on CNN." CR>)
	       (ELSE
		<TELL 'SEN-ASHER ", a distinguished harlequin, is">
		<TELL-HERE>)>>

<ROUTINE SEN-ASHER-F ()
	 <COND (<EQUAL? ,WINNER ,SEN-ASHER>
		<COND (<VERB? HELLO>
		       <TELL
"The Senator greets you and shakes your hand. His handshake is firm, warm,
and dry." CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
"\"You can't order me around! You reporters have a lot of nerve.\"" CR>)>)
	       (<AND <VERB? $REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<REVEAL-MURDER ,SEN-ASHER>
		<COND (<IN? ,PRSI ,HERE>
		       <TELL
CD ,WINNER " tells the Senator of the murder. He looks like he has been
hit with a sandbag." CR>)
		      (<NEARBY? ,SEN-ASHER>
		       <TELL
CD ,WINNER " tells the Senator something that horrifies him." CR>)>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,SEN-ASHER>
		       <TELL
"\"No! That's ridiculous! Who did it?\" He recoils from the idea as
though he had been punched." CR>)
		      (T
		       <TELL
"\"Horrible, horrible.\" The Senator hasn't yet recovered from the
revelation." CR>)>)
	       (<AND <VERB? ACCUSE> <EQUAL? ,PRSI ,GLOBAL-MURDER>>
		<TELL
"\"" ,YOU-MUST "be insane. Sure, I was in the next room when it happened.
How do you suppose that makes me feel? I was in love with her once...
I suppose I still am. I could no more kill her than, than...\" He chokes
back a sob." CR>)
	       (<VERB? EXAMINE>
		<TELL
"Senator Alan Asher is two years into a successful first term, a man the
party is already eyeing for higher office. He is tall and not quite so
handsome as to be too handsome for a politician. Even dressed as he is
in harlequin costume, he manages to look commanding and at ease." CR>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,SEN-ASHER>>
		<COND (<NOT <FSET? ,PRSI ,PERSON>>
		       <COND (<EQUAL? ,PRSI ,GLOBAL-MURDER>
			      <COND (<FSET? ,PRSO ,TOLD>
				     <TELL
"\"You know, I heard a muffled yell from the office at about ">
				     <TIME-PRINT ,YELL-TIME <>>
				     <TELL " I didn't really notice
it consciously; I was watching television and relaxing.\"" CR>)
				    (ELSE
				     <TELL
"\"What murder? Is this some sort of trick question?\"" CR>)>)
			     (ELSE
			      <TELL
"\"No comment.\"" CR>)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"Your paper has always been fair and impartial to me. I appreciate
that.\"" CR>)
		      (<EQUAL? ,PRSI ,SEN-ASHER>
		       <TELL
"\"Tell your readers I'm just a dedicated public servant.\" He grins
winningly." CR>)
		      (<IN? ,PRSI ,HERE>
		       <TELL "\"It would be impolitic to say anything.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <TELL
"\"" 'MICHAEL " is a fine man. He was a lucky man to capture " 'VERONICA ".\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA>
		       <COND (<FSET? ,PRSO ,TOLD>
			      <TELL
"The Senator tries to compose himself. \"She was always one of my greatest
friends. We knew each other for many years. How could anyone have done this
to her?\"" CR>)
			     (ELSE
			      <TELL
"\"She gives a great party. It's always a pleasure to come out here: the
pressure's off for a while and I can just relax.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <TELL
"\"She's an old friend of " 'VERONICA "'s. When they were in school together
they were roommates. Borrowing each other's clothes, stealing boyfriends
back and forth, and all that.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
"\"He is, unfortunately, not much. " 'VERONICA " despair"
<COND (<FSET? ,PRSO ,TOLD> "ed")(ELSE "s")> " of him ever amounting to
anything.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"He's a hidebound old reactionary. It's unfortunate. The trust could do
so much good with a different administrator. But " 'VERONICA " likes him.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"I've never been introduced. I know Richard is well and truly smitten,
though.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
"\"Construction is a big business around here. These suburbs are among the
fastest growing areas in the country. It's driving the Hunt Club types
further out into the country. " 'COCHRANE " is a big force in the industry,
not that anyone is terribly pleased at that.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <TELL
"\"He's done a lot of construction in the area, mostly office buildings,
and many of those for the government. You'd be surprised at how little
of the space the government occupies is actually government-owned. We're
tenants in a lot of places, and " 'OSTMANN " owns a lot of those.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"" 'BUTLER " is a family retainer. He'll live here for the rest of his life,
if he can. They'll let him, too.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
"\"Seems a nice kid. He told me he's in Law School.\"" CR>)
		      (ELSE
		       <TELL
"\"Nothing to say, not even off-the-record.\"" CR>)>)>>

<ROUTINE G-SEN-ASHER (GARG)
	 <COND (<NOT .GARG> <IMOVEMENT ,SEN-ASHER G-SEN-ASHER>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL "The Senator is becoming bored with you." CR>)>>

\

<OBJECT GLOBAL-COCHRANE
	(IN GLOBAL-OBJECTS)
	(DESC "Cochrane")
	(SDESC "Astronaut")
	(SYNONYM COCHRANE ASTRONAUT SPACEMAN BILL)
	(ADJECTIVE BILL WILLIAM MR)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON THE AN)
	(CHARACTER 8)>

<OBJECT COCHRANE
	(IN EAST-BATH)
	(SDESC "Astronaut")
	(DESC "Cochrane")
	(LDESC
"An astronaut in an itchy spacesuit is here.")
	(SYNONYM COCHRANE ASTRONAUT SPACEMAN BILL)
	(ADJECTIVE BILL WILLIAM MR)
	(ACTION COCHRANE-F)
	(FLAGS TRANSBIT PERSON AN THE)
	(CHARACTER 8)>

<GLOBAL COCHRANE-SDESC "Cochrane">

<ROUTINE COCHRANE-UNMASKS ()
	 <COND (<EQUAL? <GETP ,COCHRANE ,P?SDESC> ,COCHRANE-SDESC>
		<RFALSE>)
	       (ELSE
		<FCLEAR ,COCHRANE ,THE>
		<FCLEAR ,COCHRANE ,AN>
		<PUTP ,COCHRANE ,P?SDESC ,COCHRANE-SDESC>
		<FCLEAR ,GLOBAL-COCHRANE ,THE>
		<FCLEAR ,GLOBAL-COCHRANE ,AN>
		<PUTP ,GLOBAL-COCHRANE ,P?SDESC ,COCHRANE-SDESC>
		<PUTP ,COCHRANE ,P?LDESC
"William Cochrane, who looks like his spacesuit itches, is here.">
		<TELL
"The figure lifts its visor. \"I'm Bill " 'COCHRANE "! This costume is
so hot and itchy, I'm sorry I got it.\" He wipes his brow. ">)>>

<GLOBAL COCHRANE-SEEN-AGREEMENT? <>>

<ROUTINE COCHRANE-F ("AUX" UNMASKED?)
	 <COND (<EQUAL? ,WINNER ,COCHRANE>
		<COND (<VERB? HELLO SAY> <TELL "\"Uh, hi.\"" CR>)
		      (<AND <VERB? WHAT> <EQUAL? ,PRSO ,YOU>>
		       <COND (<COCHRANE-UNMASKS> <CRLF> <RTRUE>)
			     (ELSE
			      <TELL
"\"You know who I am: I'm " 'COCHRANE "!\"" CR>)>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
"\"Wha? Whatcha mean?\" he responds, in a slightly slurred voice." CR>)>)
	       (<VERB? EXAMINE>
		<COND (<EQUAL? <GETP ,COCHRANE ,P?SDESC> ,COCHRANE-SDESC>
		       <TELL "William " 'COCHRANE>)
		      (ELSE <TELL "The Astronaut">)>
		<TELL
 " is crammed into an ill-fitting, obviously rented, spacesuit.
The helmet is badly attached and bounces as he moves. It's clear he's
uncomfortable. It's also clear he has already had quite a lot to drink." CR>)
	       (<VERB? ACCUSE>
		<COND (<AND <FSET? ,COCHRANE ,TOLD>
			    ,COCHRANE-SEEN-AGREEMENT?>
		       <TELL
"\"You can't scare me. Sure, I'm just as happy she's dead, but I wouldn't
do it. I've hardly been out of the ballroom all night. You can't pin this
on me.\"" CR>)>)
	      (<VERB? SHOW>
	       <COCHRANE-UNMASKS>
	       <COND (<EQUAL? ,PRSO ,CARD>
		      <TELL
"\"Yeah. I just wanted to keep her from doing something she'd regret.
I just want an equal chance to buy this property. If she's going to
sell it, why a sweetheart deal with " 'OSTMANN "? I went to her office earlier
to try to convince her, but the door was locked and she wouldn't answer.">
		      <COND (<FSET? ,COCHRANE ,TOLD>
			     <TELL
" That was at about quarter of eight, so you can't pin this
on me: she was still alive then, everybody saw her.">)>
		      <TELL "\"" CR>)
		     (<EQUAL? ,PRSO ,SALE-FOLDER ,SALE-AGREEMENT>
		      <COND (,COCHRANE-SEEN-AGREEMENT?
			     <TELL
"\"Yeah. I've seen it, remember?\"" CR>
			     <RTRUE>)>
		      <SETG COCHRANE-SEEN-AGREEMENT? T>
		      <COND (<FSET? ,COCHRANE ,TOLD>
			     <TELL
"\"What a joke on Sam! He'll never get this property now! " 'MICHAEL
" will sell to me, I bet... I mean, well, it's a shame she's dead and
all, but you gotta look out for yourself.\"" CR>)
			    (ELSE
			     <SETG COCHRANE-LOOKS-FOR-OSTMANN? T>
			     <TELL
"\"Ask " 'OSTMANN " about that.\" " 'COCHRANE "'s calm
covers a less placid interior." CR>)>)>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,COCHRANE>>
		<SET UNMASKED? <COCHRANE-UNMASKS>>
		<TELL
'COCHRANE " is a little unsteady, and swallows a little more of his drink
before answering. ">
		<COND (<NOT <FSET? ,PRSI ,PERSON>>
		       <COND (<EQUAL? ,PRSI ,ASTRONAUT-COSTUME>
			      <COND (.UNMASKED? <RTRUE>)
				    (ELSE
				     <TELL "\"It itches.\"" CR>)>)
			     (<EQUAL? ,PRSI ,GLOBAL-MURDER>
			      <COND (<FSET? ,PRSO ,TOLD>
				     <TELL
"\"I didn't do it! She wasn't giving me a fair shake, but murder?
Not me!\"">)
				    (T
				     <TELL
"\"Murder? No one's been murdered. Is this a joke?\"">)>)
			     (<EQUAL? ,PRSI ,SALE ,SALE-FOLDER ,SALE-AGREEMENT>
			      <TELL
"\"That skunk " 'OSTMANN "! He's out to get me. I should have had that sale.\"">)
			     (ELSE
			      <TELL "\"I dunno.\"">)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"Reporters. Can't stand them. You seem basically okay, though.\"">)
		      (<EQUAL? ,PRSI ,COCHRANE>
		       <TELL
"\"I'm just a small businessman trying to make a profit.
Dealing with these rich types doesn't make it any
easier. Whoever said the rich were free spenders didn't know these
people.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA ,CORPSE>
		       <COND (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"She treated me like dirt, just because she never worked
for her money and I did. My hands are clean.\"">)
			     (ELSE
			      <TELL
"\"She's a fancy-pants rich girl, thinks she's too good to deal
with me. She's got another think coming!\"">)>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
"\"I could tell you some things. But " HE/SHE ,PRSI "'s
right here.\" He grins.">)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <TELL
"\"I think he'd deal with me. I can talk to him man-to-man,
but that wife of his...\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <TELL
"\"I never met her. Another one of those society types,
like Ms. Ashcroft.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
,I-DONT-KNOW "him. Everybody seems down on him, and given
this family, that means he's a good guy.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"" 'COL-MARSTON "? I hear he was a colonel in a supply battalion.
He never got closer to the front than Georgia. I could tell you a few
more things about him if I wanted to...\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"She's the ballerina, right? You know her? Want to introduce me?\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"He's a friend of the family. He and Ms. Ashcroft
were an item before she married " 'MICHAEL ".\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <TELL
"\"That slime! He'll get what's coming to him one of these days. He's got
an in with" ,REAL-ESTATE-BOARD ", and he's tight with " 'VERONICA ".
He's ruining my business!\" He angrily scans the room,
looking for " 'OSTMANN ".">)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"Thinks he's Jeeves. All stiff-upper-lip and fake
British accent.\"">)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
"\"Makes a heck of a drink, doesn't he?\"">)
		      (ELSE
		       <TELL-DONT-KNOW>)>
		<TELL " He steadies himself." CR>)>>

<ROUTINE I-DONT-KNOW-ABOUT (THAT "OPTIONAL" (CR? T))
	 <TELL ,I-DONT-KNOW "anything about ">
	 <TELL .THAT>
	 <COND (.CR? <TELL ".\"" CR>)>>

<ROUTINE TELL-DONT-KNOW ()
	 <I-DONT-KNOW-ABOUT "that">>

<GLOBAL COCHRANE-LOOKS-FOR-OSTMANN? <>>

<ROUTINE G-COCHRANE (GARG "AUX" (L <LOC ,COCHRANE>))
	 <COND (<NOT .GARG> <IMOVEMENT ,COCHRANE G-COCHRANE>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL
'COCHRANE " swallows some of his drink, then says, \"Excuse me, but I
think I need a refill.\"" CR>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<AND <EQUAL? .L ,BALLROOM-9>
			    <ENABLED? <INT I-ARGUMENT>>>
		       <GOALS? ,COCHRANE <>>
		       <RFALSE>)
		      (<EQUAL? .L ,BALLROOM-9>
		       <NEW-SCRIPT ,COCHRANE ,COCHRANE-LOOP>
		       <COND (<PROB 25>
			      <ESTABLISH-GOAL ,COCHRANE ,EAST-BATH T>
			      <COND (<EQUAL? ,HERE .L>
				     <TELL-ARRIVES ,COCHRANE>
				     <TELL
"bar, pauses, and gives his empty glass back to
the bartender." CR>)>)
			     (<EQUAL? ,HERE .L>
			      <TELL-ARRIVES ,COCHRANE>
			      <TELL
"bar and orders another drink." CR>)>)
		      (<AND <EQUAL? .L ,HALLWAY-3>
			    <NOT ,THREE-STOOGES-IN-OFFICE?>>
		       <GOALS? ,COCHRANE <>>
		       <COND (<AND <IN? ,MICHAEL ,HALLWAY-3>
				   <IN? ,COL-MARSTON ,HALLWAY-3>>
			      <GANGS-ALL-HERE>)>)
		      (<EQUAL? .L ,OFFICE>
		       <SETG THREE-STOOGES-IN-OFFICE? T>
		       <UNPRIORITIZE ,COCHRANE>
		       <NEW-SCRIPT ,COCHRANE ,COCHRANE-LOOP>
		       <GRAB-ATTENTION ,COCHRANE>
		       <RFALSE>)
		      (<EQUAL? .L ,EAST-BATH>
		       <FCLEAR ,EAST-BATH-DOOR ,OPENBIT>
		       <ESTABLISH-GOAL ,COCHRANE ,BALLROOM-9>
		       <RFALSE>)>)>>

\

<OBJECT GLOBAL-OSTMANN
	(IN GLOBAL-OBJECTS)
	(DESC "Ostmann")
	(SYNONYM OSTMANN VAMPIRE SAM SAMUEL)
	(ADJECTIVE MR SAM SAMUEL)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 9)>

<OBJECT OSTMANN
	(IN BALLROOM-9)
	(DESC "Ostmann")
	(SYNONYM OSTMANN VAMPIRE SAM SAMUEL)
	(ADJECTIVE MR SAM SAMUEL)
	(ACTION OSTMANN-F)
	(DESCFCN OSTMANN-DESC-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 9)>

<GLOBAL OSTMANN-SEEN-AGREEMENT? <>>

<ROUTINE OSTMANN-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL
"Samuel " 'OSTMANN ", "
	 <COND (<FSET? ,OSTMANN ,TOLD>
		"costumed")
	       (T "enjoying himself hugely")>
	 " as a vampire, is">
	 <TELL-HERE>>

<GLOBAL REAL-ESTATE-BOARD " the Real Estate Board">

<ROUTINE OSTMANN-F ()
	 <COND (<EQUAL? ,WINNER ,OSTMANN>
		<COND (<VERB? HELLO>
		       <TELL
"\"How do you do. My name is Samuel " 'OSTMANN ".\"" CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL 'OSTMANN " politely demurs." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"Samuel " 'OSTMANN " is a very formal, slightly pudgy vampire. He
has a black cape with a red lining, but otherwise is in full evening
dress; a somewhat old-fashioned tuxedo. The vampire effect is achieved
by a realistic set of fangs which he rubs occasionally, as though they
itched." CR>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,OSTMANN>
		       <TELL
"\"This is a terrible thing...for all of us.\" His tone indicates that
the worst thing about murder is that it's a breach of etiquette." CR>)
		      (ELSE
		       <TELL
"\"Yes. I know.\"" CR>)>)
	       (<VERB? SHOW>
		<COND (<EQUAL? ,PRSO ,SALE-AGREEMENT ,SALE-FOLDER>
		       <COND (,OSTMANN-SEEN-AGREEMENT?
			      <TELL
"\"You showed me that before. What makes you think the situation has
changed?\"" CR>)
			     (ELSE
			      <SETG OSTMANN-SEEN-AGREEMENT? T>
			      <TELL
'OSTMANN " looks surprised. \"Where did you get that?
That's the agreement " 'VERONICA " and I were supposed to sign tonight.
I wouldn't come to a party like this if I didn't have to. Well,
actually I guess I'm having a pretty good time.\"">
			      <COND (<FSET? ,OSTMANN ,TOLD>
				     <TELL
" " 'OSTMANN " is thoughtful for a moment. \"Something struck me as odd. She
put me off earlier this evening when I wanted to sign then. She said she
had some other business to take care of first. She seemed preoccupied. I tried
to change her mind but she was adamant.\"">)>
			      <CRLF>)>)>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,OSTMANN>>
		<COND (<NOT <FSET? ,PRSI ,PERSON>>
		       <COND (<EQUAL? ,PRSI ,GLOBAL-MURDER>
			      <COND (<FSET? ,PRSO ,TOLD>
				     <TELL
"\"It's terrible! She had agreed to sell me this property, we were going
to finalize the deal tonight. Someone must have wanted to stop it!\"" CR>)
				    (T
				     <TELL
,I-DONT-KNOW "of any murder.\"" CR>)>)
			     (<EQUAL? ,PRSI
				      ,SALE ,SALE-FOLDER SALE-AGREEMENT>
			      <COND (,OSTMANN-SEEN-AGREEMENT?
				     <TELL
"\"She told me this area is getting too suburban. It's no
longer a proper place to raise horses. She wants to buy up-county,
where it's still rural. There'd be a hefty profit from
selling this place, but the new one is even more expensive. She said she
could raise the money, though.\"" CR>)
				    (ELSE
				     <TELL
"\"I'm not sure I know what you're talking about. You do like to
pry into other people's business, don't you?\"" CR>)>)
			     (<IN? ,PRSI ,HERE>
			      <TELL
"\"That's an interesting " D ,PRSI ".\"" CR>)
			     (ELSE
			      <TELL
"\"I'm not sure what you want me to say.\"" CR>)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"I've never met you before, so I don't really have an opinion. You are
somewhat impolite.\"" CR>)
		      (<EQUAL? ,PRSI ,OSTMANN>
		       <TELL
"\"I'm just a businessman trying to make a profit, trying to keep busy.">
		       <COND (,OSTMANN-SEEN-AGREEMENT?
			      <TELL
" For example, what I planned to do with this property is build mostly
condominiums, if I can get the zoning. Some two-acre lots, too. This is
really the last undeveloped property in this section of the county." CR>)>
		       <TELL "\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <COND (,OSTMANN-SEEN-AGREEMENT?
			      <TELL
"\"That weasel! I've half a mind to sue, after what he tried trying to get
this property!">)
			     (ELSE
			      <TELL
"\"He's going to be in big trouble before he's done.">)>
		       <TELL
" He's already up before" ,REAL-ESTATE-BOARD " for unethical practices:
cleaning out the escrow accounts, from what I've heard. He and his agents
are a disgrace to the profession! I can't believe " 'VERONICA " invited him.
He must be crashing the party. He's certainly got enough gall!\"" CR>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
"\"Why don't you ask " HIM/HER ,PRSI " yourself?\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <COND (,OSTMANN-SEEN-AGREEMENT?
			      <TELL
"\"He's just a parasite. " 'VERONICA " told me he opposed
the sale. It's going to cost more to buy the new place and
he'll have less to play with.\"" CR>)
			     (ELSE
			      <TELL
"\"He's pathetic. What does he do? A man
should be doing something, or he's just a parasite.\"" CR>)>)
		      (<EQUAL? ,PRSI
			       ,GLOBAL-VERONICA ,GLOBAL-MURDER ,CORPSE>
		       <COND (<AND <EQUAL? ,PRSI ,GLOBAL-MURDER>
				   <NOT <FSET? ,OSTMANN ,TOLD>>>
			      <TELL
"\"What murder?\"" CR>)
			     (<FSET? ,OSTMANN ,TOLD>
			      <TELL
"\"I think someone must have wanted to stop the sale! That crook " 'COCHRANE "!
I bet he did it!\"" CR>)
			     (ELSE
			      <TELL
"\"" 'VERONICA " is a woman with a sure sense of what she wants, and a good head
for business.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <TELL
,I-DONT-KNOW "her. I understand she's a friend of " 'VERONICA "'s.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <COND (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"" 'VERONICA " told me he hated her. Now he's got the last laugh. He probably
inherits it all.\"" CR>)
			     (ELSE
			      <TELL
"\"Another parasite. The family is full of them. " 'VERONICA " is the only one
who's got any energy.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"He's an old dinosaur. A toothy one, though. I'd be wary of him. He
think's he's 'in loco parentis' to " 'VERONICA " and Richard.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"" 'VERONICA " called her 'Richard's bar girl'.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"He's done a lot for this state. Has a good understanding of the needs
of the businessman. I contributed to his last campaign.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"He looks uncomfortable.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-BARTENDER>
		       <TELL
"\"He's going to be a lawyer, he said.\"" CR>)
		      (ELSE
		       <TELL
"\"I haven't any opinion.\"" CR>)>)>>

<ROUTINE G-OSTMANN (GARG)
	 <COND (<NOT .GARG> <IMOVEMENT ,OSTMANN G-OSTMANN>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL
'OSTMANN " is getting impatient, but is too polite to say so." CR>)
	       (<EQUAL? .GARG ,G-ENROUTE>
		<C&D-SNUB>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<EQUAL? <LOC ,OSTMANN> ,BALLROOM-9>
		       <NEW-SCRIPT ,OSTMANN ,OSTMANN-LOOP>)>
		<C&D-SNUB>)>>

<ROUTINE C&D-SNUB ()
	 <COND (<AND <IN? ,OSTMANN ,HERE>
		     <IN? ,COCHRANE ,HERE>>
		<COND (,COCHRANE-LOOKS-FOR-OSTMANN?
		       <SETG COCHRANE-LOOKS-FOR-OSTMANN? <>>
		       <TELL
'COCHRANE " comes up behind " 'OSTMANN ". \"You've
got this coming!\" he yells, and takes a roundhouse swing at his nose. "
'OSTMANN " ducks and returns the blow with surprising skill, right to the
solar plexus. " 'COCHRANE " folds up like a house of cards, and drops to the
floor with a look of surprise and resentment.\"" CR>)
		      (ELSE
		       <TELL 'OSTMANN " and " D ,COCHRANE " are here, "
			     <PICK-ONE ,COCHRANE-VS-OSTMANN> CR>)>)>>

<GLOBAL COCHRANE-VS-OSTMANN
	<LTABLE 0
	"ostentatiously avoiding each other."
	"arguing about something."
	"trying to avoid each other."
	"glaring at each other.">>

\

<OBJECT GLOBAL-BUTLER
	(IN GLOBAL-OBJECTS)
	(DESC "Smythe")
	(SYNONYM SMYTHE BUTLER GORILLA)
	(ADJECTIVE MR GEORGE)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 10)>

<OBJECT BUTLER
	(IN HALLWAY-12)
	(DESC "Smythe")
	(SYNONYM SMYTHE BUTLER GORILLA)
	(ADJECTIVE MR GEORGE)
	(ACTION BUTLER-F)
	(DESCFCN BUTLER-DESC-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 10)>

<ROUTINE BUTLER-DESC-F ("OPTIONAL" (RARG <>) "AUX" OBJ)
	 <TELL 'BUTLER " the butler">
	 <COND (,ENTANGLED?
		<TELL
" appears to be tying his shoelaces with someone else's teeth, or
a similar contortion." CR>)
	       (<PRINT-CONTENTS ,BUTLER
", a gorilla of noble bearing, is carrying " ,GORILLA-COSTUME>
		<TELL "." CR>)
	       (<IN? ,BUTLER ,EAST-COAT-CLOSET>
		<TELL
" is straightening up some coats." CR>)
	       (<AND <NOT ,SLAPSTICK?>
		     <IN-MOTION? ,VERONICA>>
		<TELL
" is helping a guest with his coat." CR>)
	       (ELSE
		<TELL
", maintaining his regal bearing even though costumed as a
gorilla, waits nearby." CR>)>>

<ROUTINE BUTLER-F ()
	 <COND (<EQUAL? ,WINNER ,BUTLER>
		<COND (,ENTANGLED?
		       <TELL 'BUTLER " is in no condition to talk now." CR>)
		      (<VERB? HELLO>
		       <TELL
"\"How do you do? A lovely evening, isn't it?\"" CR>)
		      (<VERB? GIVE>
		       <COND (<EQUAL? ,PRSO ,GLASS>
			      <TELL
"\"I'm sorry, but you might cut yourself. I propose to throw this
in the trash.\"" CR>)
			     (<EQUAL? ,PRSI ,PLAYER>
			      <MOVE ,PRSO ,PRSI>
			      <TELL
"\"If you insist,\" he replies, handing you ">
			      <TELL-PRSO>)
			     (ELSE
			      <TELL
"He politely refuses." CR>)>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
'BUTLER " looks at you calmly through the eyeholes of his gorilla suit." CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"George " 'BUTLER ", the butler, is resplendent in an all-over gorilla suit,
over which he is wearing his butler's uniform (up to and including white
gloves). The effect is striking, particularly when he speaks,
as " 'BUTLER " has a British accent." CR>)
	       (<VERB? DANCE>
		<TELL
"\"I beg your pardon? I'm working, as you can see.\"" CR>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,BUTLER>
		       <TELL
"\"A tragedy.\" He seems to be genuinely saddened by the news." CR>)
		      (T
		       <TELL
"\"It is extremely improper of you to be conveying this news in such a
callous way.\"" CR>)>)
	       (<VERB? GIVE>
		<COND (<EQUAL? ,PRSO ,YOUR-COAT ,ALICIA-COAT>
		       <MOVE ,PRSO ,BUTLER>
		       <NEW-SCRIPT ,BUTLER ,BUTLER-LOOP>
		       <COND (<IN? ,BUTLER ,HERE>
			      <COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
				     <TELL
CD ,WINNER " gives " HIS/HER ,WINNER " coat to the butler." CR>)>
			      <TELL
"\"Thank you, I'll go hang it up. I believe you know your way to the
ballroom? It's down the long hall to the right. I hope you enjoy your
evening.\"" CR>)>)
		      (<EQUAL? ,PRSO ,GLASS>
		       <MOVE ,GLASS ,BUTLER>
		       <ESTABLISH-GOAL ,BUTLER ,KITCHEN T>
		       <TELL
"The butler takes it carefully. \"You could have cut yourself,\" he
comments." CR>)
		      (<IN? ,BUTLER ,HERE>
		       <TELL
"The butler politely refuses ">
		       <TELL-PRSO>)>
		<RTRUE>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,BUTLER>>
		<TELL 'BUTLER " ignores the question." CR>)>>

<GLOBAL NEW-ARRIVAL <>>

<ROUTINE G-BUTLER (GARG
		   "AUX" (NA <>) OW COAT (L <LOC ,BUTLER>) (FLG <>)
		   (HERE? <EQUAL? ,HERE .L>))
         <SET OW ,WINNER>
	 <COND (<NOT .GARG> <IMOVEMENT ,BUTLER G-BUTLER>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL
"\"Pardon me,\" says " 'BUTLER ", \"but I have work to do.\"" CR>)
	       (<EQUAL? .GARG ,G-ENROUTE>
		<COND (<NOT ,NEW-ARRIVAL>
		       <COND (<IN? ,ALICIA .L>
			      <SET NA ,ALICIA>
			      <SET COAT ,ALICIA-COAT>)
			     (<IN? ,DETECTIVE .L>
			      <SET NA ,DETECTIVE>
			      <SET COAT ,DETECTIVE-COAT>)
			     (<IN? ,DUFFY .L>
			      <SET NA ,DUFFY>
			      <SET COAT ,DUFFY-COAT>)
			     (<EQUAL? <META-LOC ,PLAYER> .L>
			      <SET NA ,PLAYER>
			      <SET COAT ,YOUR-COAT>)>
		       <COND (.NA
			      <COND (<AND <IN? .COAT .NA>
					  <NOT <FSET? .COAT ,RMUNGBIT>>>
				     <FSET .COAT ,RMUNGBIT>
				     <COND (.HERE?
					    <TELL
					     'BUTLER " says to ">
					    <COND (<EQUAL? .NA ,PLAYER>
						   <TELL "you">)
						  (ELSE <TELL D .NA>)>
					    <TELL
", \"If you would be so kind as to give me
your coat, I'll hang it up for you.\"" CR>)>
				     <COND (<NOT <EQUAL? .NA ,PLAYER>>
					    <SETG WINNER .NA>
					    <PERFORM ,V?GIVE
						     .COAT
						     ,BUTLER>
					    <SETG WINNER .OW>)>)>
			      <RETURN .HERE?>)>
		       <COND (<AND <IN? ,GLASS ,BALLROOM-8>
				   <NOT <IN-MOTION? ,VERONICA>>>
			      <ESTABLISH-GOAL ,BUTLER ,BALLROOM-8 T>
			      <RFALSE>)>)>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<UNPRIORITIZE ,BUTLER>
		<COND (<IN? ,BUTLER ,HALL>
		       <COND (,NEW-ARRIVAL
			      <SET FLG <NEW-ARRIVAL-STUFF ,BUTLER>>)
			     (<EQUAL? ,HERE ,HALL>
			      <SET FLG T>
			      <TELL
"The butler looks out the " 'FRONT-DOOR ", finds no one waiting, and resumes
his regular rounds." CR>)>
		       <NEW-SCRIPT ,BUTLER ,BUTLER-LOOP>
		       .FLG)
		      (<IN? ,BUTLER ,EAST-COAT-CLOSET>
		       <COND (<DUMP-COATS>
			      <COND (.HERE?
				     <TELL
'BUTLER " hangs the coat in the closet." CR>)>)>)
		      (<EQUAL? .L ,BALLROOM-8>
		       <COND (<IN? ,GLASS ,BALLROOM-8>
			      <MOVE ,GLASS ,BUTLER>
			      <ESTABLISH-GOAL ,BUTLER ,KITCHEN T>
			      <COND (<IN-BALLROOM? ,PLAYER>
				     <TELL
'BUTLER " unobtrusively sweeps up " THE ,GLASS "." CR>)>)>)
		      (<AND <EQUAL? .L ,KITCHEN>
			    <IN? ,GLASS ,BUTLER>>
		       <COND (<EQUAL? ,HERE ,KITCHEN>
			      <TELL 'BUTLER " dumps " THE ,GLASS " in ">)>
		       <COND (<IN? ,TRASH-BASKET ,KITCHEN>
			      <MOVE ,GLASS ,TRASH-BASKET>
			      <COND (<EQUAL? ,HERE ,KITCHEN>
				     <TELL THE ,TRASH-BASKET "." CR>)>)
			     (ELSE
			      <REMOVE ,GLASS>
			      <COND (<EQUAL? ,HERE ,KITCHEN>
				     <TELL "the garbage disposal." CR>)>)>)>)>>

<ROUTINE DUMP-COATS ("AUX" N X (ROBBED? <>))
	 <SET X <FIRST? ,BUTLER>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN .ROBBED?>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <FSET? .X ,TAKEBIT>
			     <NOT <EQUAL? .X ,GLASS>>>
			<MOVE .X ,EAST-COAT-CLOSET>
			<FCLEAR .X ,NDESCBIT>
			<SET ROBBED? .X>)>
		 <SET X .N>>>

<OBJECT TRASH-BASKET
	(IN KITCHEN)
	(SYNONYM BASKET TRASH TRASHBASKET)
	(ADJECTIVE TRASH)
	(FDESC "In the corner is a trash basket.")
	(DESC "trash basket")
	(ACTION TRASH-BASKET-F)
	(CAPACITY 15)
	(SIZE 15)
	(FLAGS SEARCHBIT CONTBIT OPENBIT TAKEBIT BURNBIT)>

<ROUTINE TRASH-BASKET-F ()
	 <COND (<VERB? LOOK-INSIDE EXAMINE SEARCH>
		<COND (<IN? ,GLASS ,TRASH-BASKET>
		       <TELL
"A " 'GLASS " is on top">)
		      (ELSE
		       <TELL
"It's nearly full">)>
		<TELL " of uninteresting garbage">
		<PRINT-CONTENTS ,TRASH-BASKET ", including " ,GLASS>
		<TELL "." CR>)>>

\

<OBJECT GLOBAL-BARTENDER
	(IN GLOBAL-OBJECTS)
	(DESC "Johnson")
	(SYNONYM JACK BARTENDER JOHNSON DOMINO)
	(ADJECTIVE MR JACK)
	(ACTION GLOBAL-PERSON-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 11)>

<OBJECT BARTENDER
	(IN BALLROOM-9)
	(DESC "Johnson")
	(LDESC
"The bartender is busy behind the bar, his only concession to the party a
small domino mask.")
	(SYNONYM JACK BARTENDER JOHNSON DOMINO)
	(ADJECTIVE MR JACK)
	(ACTION BARTENDER-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 11)>

<GLOBAL HEY-BARTENDER "\"Hello. What'll it be?\"">

<ROUTINE BARTENDER-F ("AUX" OW)
	 <SET OW ,WINNER>
	 <COND (<EQUAL? ,WINNER ,BARTENDER>
		<COND (<VERB? HELLO>
		       <TELL ,HEY-BARTENDER CR>)
		      (<VERB? GIVE MAKE>
		       <COND (<NOT ,PRSI> <RFALSE>)
			     (<OR <EQUAL? ,PRSO ,DRINK ,GLOBAL-DRINK>
				  <EQUAL? ,PRSI ,DRINK ,GLOBAL-DRINK>>
			      <COND (<OR <EQUAL? ,PRSI ,ME ,PLAYER>
					 <EQUAL? ,PRSO ,ME ,PLAYER>>
				     <SETG DRINK-COUNT <+ ,DRINK-COUNT 1>>
				     <TELL "\"Sure.">
				     <COND (<IN? ,DRINK ,PLAYER>
					    <TELL
" Here, let me take your old one.">)>
				     <THIS-IS-IT ,DRINK>
				     <MOVE ,DRINK ,PLAYER>
				     <PUTP ,DRINK ,P?SIZE 10>
				     <COND (<G? ,DRINK-COUNT 3>
					    <TELL
" Don't you think you've had enough?\"" CR>)
					   (T
					    <TELL
"\" The bartender swiftly and efficiently mixes a drink, then hands it to
you." CR>)>)
				    (<OR <FSET? ,PRSO ,PERSON>
					 <FSET? ,PRSI ,PERSON>>
				     <TELL
"\"" ,YOU-SHOULD "let people order their own drinks.\"" CR>)
				    (ELSE
				     <TELL "\"Pardon?\"" CR>)>)
			     (ELSE
			      <TELL
"\"I'm afraid I can't make one of those.\"" CR>)>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
"\"Sorry, I've been hired to mix drinks and that's all I'll do.\"" CR>)>)
	       (<VERB? HELLO>
		<TELL ,HEY-BARTENDER CR>)
	       (<VERB? TIP>
		<TELL "\"Thanks.\"" CR>)
	       (<VERB? ASK-FOR>
		<COND (<EQUAL? ,PRSI ,DRINK ,GLOBAL-DRINK>
		       <SETG WINNER ,BARTENDER>
		       <PERFORM ,V?GIVE ,DRINK ,PLAYER>
		       <SETG WINNER .OW>
		       <RTRUE>)
		      (T
		       <TELL
"\"I don't have that.\"" CR>)>)
	       (<AND <VERB? REVEAL> <EQUAL? ,PRSO ,GLOBAL-MURDER>>
		<COND (<REVEAL-MURDER ,BARTENDER>
		       <TELL
"\"I hope I'll still get paid.\" He realizes that wasn't a very tactful
remark, and tries to recover. \"It's too bad.\"" CR>)
		      (ELSE
		       <TELL
"\"I know. You'd think it would quiet these people down, but it
hasn't.\"" CR>)>)
	       (<VERB? EXAMINE>
		<TELL
"Jack Johnson, the bartender, is a well-barbered young man wearing a red
uniform and, as his only concession to the theme of the party, a simple
domino mask." CR>)
	       (<VERB? DANCE>
		<TELL "\"Sorry, I'm on duty.\"" CR>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,BARTENDER>>
		<COND (<EQUAL? ,PRSI ,DRINK ,GLOBAL-DRINK ,BAR>
		       <TELL
"\"I know a lot about drinks.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MURDER>
		       <COND (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"It certainly puts a damper on the evening for me, but no one else
seems too concerned.\"" CR>)
			     (T
			      <TELL
"\"What? What murder?\"" CR>)>)
		      (<EQUAL? ,PRSI ,PLAYER>
		       <TELL
"\"I'm interested in things like libel law, and the first amendment. We
should talk later, I'm sure your views are interesting.\"" CR>)
		      (<EQUAL? ,PRSI ,BARTENDER>
		       <TELL
"\"I'm Jack Johnson. I'm trying to pay some of my tuition by working
behind bars. Get it? Well, I get quite a view of mankind. It's good
practice, I'm going to be a lawyer.\"" CR>)
		      (<IN? ,PRSI ,HERE>
		       <TELL
"Glancing discreetly at the subject of the inquiry, Jack only smiles." CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-MICHAEL>
		       <TELL
"\"Nice guy, sort of the hail-fellow-well-met type. Practically broke my hand
shaking it when I first came in. Likes a very dry martini, already had a
couple tonight. 'You want dry?' I told him. I pour the gin in, and then I
kinda wave the fumes from the vermouth over the glass. He thought that was
a good one...\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-VERONICA>
		       <TELL
"\"One of her friends told her about me. I worked a party over there a month
or so ago, so Ms. Ashcroft asks the agency for me
specifically. I can use the dough. Going to Law School, and it ain't cheap.\"
He looks significantly at the tip glass. \"Anyway, she had a Singapore Sling:
most of these women like a sweet drink.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-LINDA>
		       <TELL
"\"A knockout, isn't she? She actually drinks sloe
gin fizzes. I didn't think anybody over 21 could stand them.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-RICHARD>
		       <TELL
"\"He seems sort of beaten down. You see too many of them in
this business. Like they're carrying something too heavy.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COL-MARSTON>
		       <TELL
"\"A very distinguished gentleman, and he knows it. Of course, the fact
that he knows it spoils the whole effect.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-ALICIA>
		       <COND (,ALICIA-HERE?
			      <TELL
"\"Nice harem costume.\"" CR>)
			     (ELSE
			      <TELL "\"I haven't seen her.\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-SEN-ASHER>
		       <TELL
"\"The man's a true politician. Not even up for election for another four
years, and he's doing the whole campaign bit the first time he comes over
for a drink. Of course, I guess I'm the closest thing there is to the
public here, the average income in this room must be something. He told
me he's a teetotaler, too: ordered a soft drink. His father was an alcoholic
and the Senator could never bring himself to drink, remembering.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-COCHRANE>
		       <TELL
"\"That one? He'll be out before the night's over. Straight bourbon, no
ice, and beer chasers. I'm surprised he can stand up now. He's had three
already.\"" CR>)
		      (<EQUAL? ,PRSI ,GLOBAL-OSTMANN>
		       <COND (<FSET? ,PRSO ,TOLD>
			      <TELL
"\"He's taking " 'VERONICA "'s death hard. I wonder why.\"" CR>)
			     (ELSE
			      <TELL
"\"He's very pleased with himself, isn't he?\"" CR>)>)
		      (<EQUAL? ,PRSI ,GLOBAL-BUTLER>
		       <TELL
"\"He's been quite helpful. He obviously knows his job.\"" CR>)
		      (ELSE
		       <I-WOULDNT-KNOW>)>)>>

<ROUTINE I-WOULDNT-KNOW ()
	 <TELL
"\"I wouldn't know.\"" CR>>

<GLOBAL DRINK-COUNT 0>

<OBJECT DRINK
	(SYNONYM DRINK LIQUOR REFILL)
	(ADJECTIVE MIXED COLD)
	(DESC "drink")
	(FLAGS TAKEBIT DRINKBIT)
	(SIZE 10)
	(ACTION DRINK-F)>

<OBJECT GLOBAL-DRINK
	(IN GLOBAL-OBJECTS)
	(SYNONYM DRINK LIQUOR REFILL)
	(ADJECTIVE MIXED COLD)
	(DESC "drink")
	(FLAGS DRINKBIT)
	(SIZE 10)
	(ACTION DRINK-F)>

<ROUTINE DRINK-F ("AUX" OW)
	 <SET OW ,WINNER>
	 <COND (<VERB? ASK-FOR>
		<COND (<EQUAL? ,HERE ,BALLROOM-9>
		       <SETG WINNER ,BARTENDER>
		       <PERFORM ,V?GIVE ,DRINK .OW>
		       <SETG WINNER .OW>
		       <RTRUE>)
		      (ELSE
		       <TELL
"Drinks may be obtained at the bar." CR>)>)
	       (<VERB? THROW POUR-ON>
		<PUTP ,PRSO ,P?SIZE 5>
		<RFALSE>)
	       (<VERB? DRINK>
		<COND (<NOT <EQUAL? ,PRSO ,DRINK>>
		       <TELL
"Perhaps you've had one too many already. There is no drink">
		       <TELL-HERE>)
		      (<EQUAL? <GETP ,DRINK ,P?SIZE> 5>
		       <TELL
"It's empty. If you want more, you'll need a refill." CR>)
		      (ELSE
		       <PUTP ,DRINK ,P?SIZE <- <GETP ,DRINK ,P?SIZE> 1>>
		       <TELL
"You sip the drink. It's cold and tasty, but perhaps a little stronger
than you would like." CR>)>)
	       (<VERB? TAKE>
		<COND (<IN? ,DRINK ,PLAYER>
		       <TELL
"You already have one." CR>)
		      (<AND <EQUAL? ,HERE ,BALLROOM-9>
			    <NOT <IN? ,DRINK ,HERE>>>
		       <PERFORM ,V?ORDER ,DRINK>
		       <RTRUE>)>)>>

<ROUTINE G-BARTENDER (GARG)
	 <COND (<NOT .GARG> <IMOVEMENT ,BARTENDER G-BARTENDER>)>>

\

<OBJECT GLOBAL-DETECTIVE
	(IN GLOBAL-OBJECTS)
	(DESC "detective")
	(SYNONYM DETECTIVE)
	(FLAGS TRANSBIT PERSON THE)
	(ACTION GLOBAL-PERSON-F)
	(CHARACTER 12)>

<OBJECT DETECTIVE
	(DESC "detective")
	(SYNONYM DETECTIVE)
	(ACTION DETECTIVE-F)
	(DESCFCN DETECTIVE-DESC-F)
	(CONTFCN DETECTIVE-F)
	(FLAGS TRANSBIT PERSON THE SEARCHBIT)
	(CHARACTER 12)>

<GLOBAL FROB <>>
<GLOBAL LAST-FROB <>>

<ROUTINE DETECTIVE-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL CTHE ,DETECTIVE>
	 <COND (<EQUAL? <LOC ,DETECTIVE> ,BALLROOM-8 ,BALLROOM-9>
		<TELL
" stands nearby, weighing evidence." CR>)
	       (<IN? ,DETECTIVE ,OFFICE>
		<SETG LAST-FROB ,FROB>
		<SETG FROB <PICK-ONE ,OFFICE-FROBS>>
		<TELL " is examining " THE ,FROB "." CR>)
	       (ELSE
		<TELL " is here">
		<COND (<EQUAL? <META-LOC ,CORPSE> ,HERE>
		       <TELL ", examining " D ,CORPSE>)
		      (<AND <L? ,DETECTIVE-SEEN 5>
			    <OR ,DETECTIVE-SEEN-CORPSE?
				,DETECTIVE-SEEN-ROPE?
				,DETECTIVE-SEEN-BULLET?>>
		       <TELL
", eyeing you suspiciously">)>
		<TELL "." CR>)>>

<GLOBAL OFFICE-FROBS
	<LTABLE 0
		LARGE-DESK
		SMALL-DESK
		FILE-CABINET
		TELEPHONE
		TRASH
		OFFICE-JUNK
		COMPUTER
		DISK>>

<GLOBAL PLAYER-MOVED-BODY? <>>
<GLOBAL PLAYER-SEEN-WITH-BODY? <>>
<GLOBAL DETECTIVE-BEEN-TO-OFFICE? <>>
<GLOBAL DETECTIVE-SEEN-BULLET? <>>
<GLOBAL DETECTIVE-SEEN-BULLET-PRINTS? <>>

<GLOBAL DETECTIVE-SEEN-CORPSE? <>> ;"1"
<GLOBAL DETECTIVE-SEEN-ROPE? <>> ;"2 -- implicates player"
<GLOBAL DETECTIVE-SEEN-COAT? <>> ;"3 -- implicates Alicia"
<GLOBAL DETECTIVE-SEEN-GLASS? <>> ;"4 -- you suspect imposture"
<GLOBAL DETECTIVE-SEEN-HAIR? <>> ;"5 -- casts suspicion on Alicia"
<GLOBAL DETECTIVE-SEEN-CARD? <>> ;"6 -- casts suspicion on Cochrane"
<GLOBAL DETECTIVE-SEEN-AGREEMENT? <>> ;"7 -- casts suspicion on Cochrane"
<GLOBAL DETECTIVE-SEEN-TRUST-DOCUMENTS? <>> ;"8 -- implicates Marston"
<GLOBAL DETECTIVE-SEEN-LIST? <>> ;"9 -- implicates Marston and Michael"

<GLOBAL GLASS-ANALYZED? <>> ;"10 -- you suspect imposture"
<GLOBAL GLASS-ANALYZED-FOR-PRINTS? <>> ;"11 -- implicates Alicia as acc."
<GLOBAL DETECTIVE-TOLD-ABOUT-RAIN? <>> ;"12 -- Alicia was here early."

<CONSTANT DETECTIVE-CONVINCED 12> ;"should equal number of clues"
<GLOBAL DETECTIVE-SEEN 0>

<ROUTINE DETECTIVE-F ("AUX" OSEEN)
	 <COND (<EQUAL? ,WINNER ,DETECTIVE>
	        <COND (<AND <VERB? GIVE>
			    <EQUAL? ,PRSO ,DETECTIVE-COAT>
			    <EQUAL? ,PRSI ,BUTLER>>
		       <COND (<IN? ,BUTLER ,HERE>
			      <TELL
CTHE ,DETECTIVE " politely refuses to yield the trenchcoat." CR>)>
		       <RTRUE>)
		      (<AND <NOT ,DETECTIVE-BEEN-TO-OFFICE?>
			    <IN? ,DETECTIVE ,HERE>
			    <NOT <VERB? $DISCOVER $REVEAL>>>
		       <TELL
"\"Can't this wait until I've visited the scene of the crime?\"" CR>)
		      (<AND <VERB? LOOK-INSIDE>
			    <EQUAL? ,PRSO ,FAIRY-MASK>>
		       <COND (<IN? ,HAIR ,FAIRY-MASK>
			      <FCLEAR ,HAIR ,INVISIBLE>
			      <SETG WINNER ,PLAYER>
			      <PERFORM ,V?SHOW ,HAIR ,DETECTIVE>
			      <SETG WINNER ,DETECTIVE>
			      <RTRUE>)
			     (T
			      <TELL
"\"Yes, I'm looking... What's inside that's so interesting? I don't see
any blood or anything.\"" CR>)>)
		      (<VERB? ARREST ACCUSE>
		       <COND (<EQUAL? ,PRSI ,GLOBAL-EMBEZZLEMENT>
			      <TELL
"\"We'll worry about that after we've solved the murder, okay?\"" CR>)
			     (<EQUAL? ,PRSO ,OBJECT-PAIR>
			      <COND (<G? <GET ,P-PRSO ,P-MATCHLEN> 2>
				     <TELL
"\"Sure, why don't I just run them all in?\"" CR>)
				    (<AND <GETP <1 ,P-PRSO> ,P?CHARACTER>
					  <GETP <2 ,P-PRSO> ,P?CHARACTER>>
				     <ARREST <LOCALIZE <1 ,P-PRSO>>
					     <LOCALIZE <2 ,P-PRSO>>>)
				    (ELSE
				     <TELL
"\"Arrested development, that's what you've got.\"" CR>)>)
			     (<AND <GETP ,PRSO ,P?CHARACTER>
				   <NOT <EQUAL? ,PRSO
						,VERONICA
						,GLOBAL-VERONICA>>>
			      <COND (<G? ,DETECTIVE-SEEN 4>
				     <ARREST <LOCALIZE ,PRSO>>)
				    (ELSE
				     <TELL
"\"Whoa! Who's " THE ,DETECTIVE " here? If you can give me enough good reasons
to arrest someone, I might listen to you, but you haven't given me
enough!\"" CR>)>)
			     (ELSE
			      <TELL
"\"That's the silliest thing I've ever heard.\"" CR>)>)
		      (<VERB? ANALYZE>
		       <COND (<NOT <EQUAL? <META-LOC ,PRSO> ,HERE ,POLICE-LAB>>
			      <NOT-HERE ,PRSO>
			      <RTRUE>)
			     (<EQUAL? ,PRSO ,GLASS>
			      <CHECK-GLASS>)
			     (<EQUAL? ,PRSI ,GLOBAL-FINGERPRINTS>
			      <TELL
"\"I doubt we'll find any " 'GLOBAL-FINGERPRINTS " on " THE ,PRSO ".\"" CR>)
			     (<EQUAL? ,PRSO ,STAIN>
			      <TELL
CTHE ,DETECTIVE " reaches down and snips a small sample of stained cloth
from the costume." CR>
			      <CHECK-JUNK ,STAIN-SAMPLE>)
			     (<EQUAL? ,PRSO ,HAIR>
			      <COND (<IN? ,HAIR ,FAIRY-MASK>
				     <COND (<NOT ,DETECTIVE-SEEN-HAIR?>
					    <SETG DETECTIVE-SEEN-HAIR? T>
					    <SETG DETECTIVE-SEEN
						  <+ ,DETECTIVE-SEEN 1>>)>
				     <CHECK-JUNK ,HAIR>)
				    (T
				     <TELL
"\"What's the point of analyzing this hair after you've been fooling around
with it?\"" CR>)>)
			     (<EQUAL? ,PRSO ,FAIRY-MASK>
			      <CHECK-JUNK ,FAIRY-MASK>)
			     (<EQUAL? ,PRSO ,CORPSE>
			      <TELL
"\"I think I'll leave that to the coroner. For the moment, it's enough
that she's dead.\"" CR>)
			     (ELSE
			      <TELL
"\"I don't think an analysis of " THE ,PRSO " would reveal any useful
information.\"" CR>)>)
		      (<VERB? COMPARE>
		       <COND (<AND <OR <EQUAL? ,PRSO ,HAIR ,VERONICA-HAIR>
				       <EQUAL? ,PRSO ,ALICIA-HAIR ,LINDA-HAIR>>
				   <OR <EQUAL? ,PRSI ,HAIR ,VERONICA-HAIR>
				       <EQUAL? ,PRSI
					       ,ALICIA-HAIR
					       ,LINDA-HAIR>>>
			      <TELL
"The detective compares the hairs. \"These hairs are ">
			      <COND (<AND <EQUAL? ,PRSO ,PRSI ,HAIR>
					  <EQUAL? ,PRSI ,PRSO ,ALICIA-HAIR>>
				     <TELL "quite similar">)
				    (T
				     <TELL "not alike">)>
			      <TELL ".\"" CR>)
			     (T
			      <TELL
"\"How about apples and oranges?\"" CR>)>)
		      (<VERB? TELL ASK-ABOUT>
		       <TELL
"\"I'll ask the questions here.\"" CR>)
		      (<VERB? FIND>
		       <COND (<EQUAL? <META-LOC ,PRSO> ,HERE>
			      <TELL "\"Not too observant, are you?\"" CR>)
			     (ELSE
			      <TELL
"\"It would help if you told me where to look.\"" CR>)>)
		      (<OR <DONT-HANDLE?>
			   <VERB? FINGERPRINT>>
		       <RFALSE>)
		      (ELSE
		       <TELL
"\"I'm very busy. There's been a murder, in case you haven't noticed.\"" CR>)>)
	       (<VERB? PHONE>
		<PERFORM ,V?PHONE ,POLICE>
		<RTRUE>)
	       (<AND <VERB? EXAMINE> <EQUAL? ,PRSO ,DETECTIVE>>
		<TELL
CTHE ,DETECTIVE " is quiet and intense, wearing a trenchcoat and a crumpled
hat. The trenchcoat and hat are still wet from the rain." CR>)
	       (<AND <VERB? SHOW GIVE> <EQUAL? ,PRSI ,DETECTIVE>>
		<SET OSEEN ,DETECTIVE-SEEN>
		<TELL CTHE ,DETECTIVE>
		<COND (<EQUAL? ,PRSO ,CORPSE>
		       <TELL
" comes over.">)
		      (<NOT ,DETECTIVE-BEEN-TO-OFFICE?>
		       <TELL
" says, \"Can't this wait until I've visited the scene of the crime?\"" CR>
		       <RTRUE>)
		      (<IN? ,PRSO ,DETECTIVE>
		       <TELL
" looks at you strangely and then shows " THE ,PRSO " to you." CR>
		       <RTRUE>)
		      (<OR <EQUAL? ,PRSO ,GLASS-ANALYSIS ,HAIR-ANALYSIS>
			   <EQUAL? ,PRSO ,NULL-ANALYSIS ,STAIN-ANALYSIS>>
		       <MOVE ,PRSO ,DETECTIVE>
		       <TELL
" takes it back. \"Thanks, I hope you found it interesting.\"" CR>
		       <RTRUE>)
		      (<AND <EQUAL? ,PRSO ,HAIR>
			    <IN? ,HAIR ,FAIRY-MASK>>
		       <COND (<IN? ,FAIRY-MASK ,DETECTIVE>
			      <TELL
" looks inside the mask.">)
			     (ELSE
			      <FSET ,FAIRY-MASK ,TRYTAKEBIT>
			      <MOVE ,FAIRY-MASK ,DETECTIVE>
			      <TELL
" takes the mask, noting the hair as you point it out.">)>)
		      (<IN? ,PRSO ,FIREPLACE>
		       <MOVE ,PRSO ,DETECTIVE>
		       <TELL
" snatches it from the fireplace.">)
		      (<IN? ,PRSO ,GLOBAL-OBJECTS>
		       <TELL
" is confused. \"What are you trying to tell me about?\"" CR>
		       <RTRUE>)
		      (<OR <FSET? ,PRSO ,PERSON>
			   <GLOBAL-IN? ,PRSO ,HERE>
			   <NOT <FSET? ,PRSO ,TAKEBIT>>>
		       <TELL
" looks at " THE ,PRSO ".">)
		      (<AND <FSET? ,PRSO ,TRYTAKEBIT>
			    <NOT <EQUAL? ,PRSO ,GLASS ,BULLET ,FAIRY-MASK>>
			    <NOT <HELD? ,PRSO ,PLAYER>>>
		       <TELL
" says, \"Would you mind bringing it over?\"" CR>
		       <RTRUE>)
		      (<VERB? SHOW>
		       <MOVE ,PRSO ,DETECTIVE>
		       <FSET ,PRSO ,TRYTAKEBIT>
		       <TELL
" looks at " THE ,PRSO " for a moment, then takes it.">)
		      (ELSE
		       <MOVE ,PRSO ,DETECTIVE>
		       <FSET ,PRSO ,TRYTAKEBIT>
		       <TELL
" takes " THE ,PRSO ".">)>
		<COND (<EQUAL? ,JUNK-COUNT 4>
		       <TELL
" \"Go away and stop bothering me!\"" CR>)
		      (<EQUAL? ,PRSO ,CORPSE>
		       <TELL " " CTHE ,DETECTIVE>
		       <COND (,DETECTIVE-SEEN-CORPSE?
			      <TELL
" looks at the corpse, and replies, \"Show me something
I haven't already seen!\"" CR>)
			     (ELSE
			      <SETG DETECTIVE-SEEN-CORPSE? T>
			      <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN>>
			      <TELL
" examines the body." CR>)>)
		      (<EQUAL? ,PRSO ,ROPE>
		       <TELL " " CTHE ,DETECTIVE " examines the rope">
		       <COND (<NOT ,DETECTIVE-SEEN-ROPE?>
			      <SETG DETECTIVE-SEEN-ROPE? T>
			      <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>
			      <TELL
" with interest">)>
		       <TELL "." CR>)
		      (<EQUAL? ,PRSO ,CARD>
		       <COND (,DETECTIVE-SEEN-CARD?
			      <TELL
" \"I've seen that already.\"" CR>)
			     (ELSE
			      <SETG DETECTIVE-SEEN-CARD? T>
			      <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>
			      <COND (,DETECTIVE-SEEN-AGREEMENT?
				     <TELL
" \"This certainly seems to implicate " 'COCHRANE ". He seems hot-headed
enough to commit murder, and the sale provides a motive.\"" CR>)
				    (ELSE
				     <TELL
" \"I wonder what this means? What was she doing that she might regret?
It certainly casts some suspicion on " 'COCHRANE ".\"" CR>)>)>)
		      (<OR <EQUAL? ,PRSO ,SALE-AGREEMENT>
			   <AND <EQUAL? ,PRSO ,SALE-FOLDER>
				<IN? ,SALE-AGREEMENT ,SALE-FOLDER>>>
		       <COND (<NOT ,DETECTIVE-SEEN-AGREEMENT?>
			      <SETG DETECTIVE-SEEN-AGREEMENT? T>
			      <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>
			      <TELL
" \"If someone wanted to prevent this sale,
it might have been worth committing a murder to do. ">
			      <COND (,DETECTIVE-SEEN-CARD?
				     <TELL "Could it have been " 'COCHRANE>)
				    (T
				     <TELL "But
who could that have been">)>
			      <TELL "?\"" CR>)
			     (ELSE
			      <TELL
" \"Yes, I've seen that. Stop bothering me!\"" CR>)>)
		      (<EQUAL? ,PRSO ,ALICIA-COAT>
		       <COND (<NOT ,DETECTIVE-SEEN-COAT?>
			      <SETG DETECTIVE-SEEN-COAT? T>
			      <COND (<NOT ,DETECTIVE-TOLD-ABOUT-RAIN?>
				     <TELL
" \"I don't see the significance of this. It's been raining all night,
as far as I know. Everyone's coat is wet.\"" CR>)
				    (ELSE
				     <SETG DETECTIVE-SEEN
					   <+ ,DETECTIVE-SEEN 2>>
				     <TELL
" \"Hmm. When Alicia arrived it wasn't raining, and this coat is wet! She
must have really been outside during the rain.\"" CR>)>)
			     (ELSE
			      <TELL
" \"Yes, it's still wet.\"" CR>)>)
		      (<OR <EQUAL? ,PRSO ,TRUST-DOCUMENTS>
			   <AND <EQUAL? ,PRSO ,TRUST-FOLDER>
				<IN? ,TRUST-DOCUMENTS ,TRUST-FOLDER>>>
		       <COND (<NOT ,DETECTIVE-SEEN-TRUST-DOCUMENTS?>
			      <SETG DETECTIVE-SEEN-TRUST-DOCUMENTS? T>
			      <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>
			      <FCLEAR ,TRUST-DOCUMENTS ,NDESCBIT>
			      <TELL
" \"Where did you get this? It's important!">
			      <COND (,DETECTIVE-SEEN-LIST?
				     <TELL
" This means that " 'MICHAEL " and " 'COL-MARSTON " were embezzling from the family
trust. And further, " 'VERONICA " knew it!">)>
			      <TELL "\"" CR>)
			     (ELSE
			      <TELL
" \"Don't you have anything new to show me?\"" CR>)>)
		      (<EQUAL? ,PRSO ,GLASS>
		       <COND (<NOT ,DETECTIVE-SEEN-GLASS?>
			      <TELL " ">
			      <CHECK-GLASS>)
			     (ELSE
			      <TELL
" \"It's the same glass, right?\"" CR>)>)
		      (<EQUAL? ,PRSO ,FAIRY-MASK>
		       <TELL
" \"What's so interesting about this mask?\"" CR>)
		      (<EQUAL? ,PRSO ,HAIR>
		       <COND (<AND <IN? ,HAIR ,FAIRY-MASK>
				   <NOT <FSET? ,HAIR ,INVISIBLE>>>
			      <COND (<NOT ,DETECTIVE-SEEN-HAIR?>
				     <SETG DETECTIVE-SEEN-HAIR? T>
				     <SETG DETECTIVE-SEEN
					   <+ ,DETECTIVE-SEEN 1>>
				     <TELL
" \"A " 'HAIR ", eh? " 'VERONICA "'s hair was blonde. How did a hair this color
get into this mask?\"" CR>)
				    (ELSE
				     <TELL
" \"Same old hair, eh?\"" CR>)>)
			     (ELSE
			      <TELL
" \"It looks like a hair. What is it supposed to prove? You're going to be
in deep trouble if you've been disturbing evidence!\"" CR>)>)
		      (<EQUAL? ,PRSO ,INVESTOR-LIST>
		       <COND (<NOT ,DETECTIVE-SEEN-LIST?>
			      <SETG DETECTIVE-SEEN-LIST? T>
			      <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>
			      <COND (,DETECTIVE-SEEN-TRUST-DOCUMENTS?
				     <TELL
" " CTHE ,DETECTIVE " reads the paper with growing excitement. \"This is it!
The motive I've been looking for!\"" CR>)
				    (ELSE
				     <TELL
" \"What's the significance of this? " 'COL-MARSTON " and " 'MICHAEL " were co-investors
in something?\"" CR>)>)
			     (ELSE
			      <TELL
" \"Seen it before.\"" CR>)>)
		      (ELSE
		       <SETG JUNK-COUNT <+ ,JUNK-COUNT 1>>
		       <TELL " " <GET ,JUNK-STRINGS ,JUNK-COUNT> CR>)>
		<COND (<G? ,DETECTIVE-SEEN .OSEEN>
		       <GRAB-ATTENTION ,DETECTIVE>)>
		<RTRUE>)
	       (<AND <VERB? TELL-ME> <EQUAL? ,PRSO ,DETECTIVE>>
		<COND (<EQUAL? ,PRSI ,WEATHER>
		       <COND (,SAW-RAIN-SLACK-OFF?
			      <COND (<NOT ,DETECTIVE-TOLD-ABOUT-RAIN?>
				     <SETG DETECTIVE-TOLD-ABOUT-RAIN? T>
				     <COND (<NOT ,DETECTIVE-SEEN-COAT?>
					    <TELL
"You try to explain the significance of the rain, but " THE ,DETECTIVE " doesn't
understand what you're getting at." CR>)
					   (ELSE
					    <SETG DETECTIVE-SEEN
						  <+ ,DETECTIVE-SEEN 2>>
					    <TELL
CTHE ,DETECTIVE " listens as you explain how when Alicia arrived the rain was
falling very lightly, but that her overcoat was soaked, which is why you
turned it over to the authorities. " CTHE ,DETECTIVE " says, \"That may mean
she was here earlier when the rain was pelting down, that she didn't arrive
when she said she did.\"" CR>)>)
				    (T
				     <TELL
"\"You've already told me this.\"" CR>)>)
			     (T
			      <TELL
"You haven't seen anything significant about the weather, so you can't
tell " THE ,DETECTIVE " about it." CR>)>)
		      (<AND <EQUAL? ,PRSI ,BMW>
			    ,DETECTIVE-SEEN-TRUST-DOCUMENTS?>
		       <TELL
"\"Ah! Either " 'MICHAEL " or someone with access to his keys must have
put the documents there.\"" CR>)
		      (ELSE
		       <TELL
CTHE ,DETECTIVE " doesn't seem very interested." CR>)>
		<COND (<G? ,DETECTIVE-SEEN .OSEEN>
		       <GRAB-ATTENTION ,DETECTIVE>)>
		<RTRUE>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,DETECTIVE>>
		<COND (<EQUAL? ,PRSI ,DETECTIVE>
		       <TELL
"\"I'm a detective. That's all you need to know right now.\"" CR>)
		      (<EQUAL? ,PRSI ,DUFFY ,GLOBAL-DUFFY>
		       <TELL
"\"" 'DUFFY " is my assistant, and a finer public servant you're
unlikely to find.\"" CR>)
		      (ELSE
		       <TELL
"\"I don't reveal my methods, particularly to potential suspects.\"" CR>)>)
	       (<AND <VERB? TAKE> <IN? ,PRSO ,DETECTIVE>>
		<TELL
"\"You can't have that. It's evidence.\"" CR>)
	       (<VERB? REPLY>
		<TELL CTHE ,DETECTIVE " listens intently." CR>)
	       (<CAUGHT-WITH-BODY?>
		<COND (<NOT ,DETECTIVE-SEEN-CORPSE?>
		       <SETG DETECTIVE-SEEN-CORPSE? T>
		       <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>)>
		<I-START-ARREST>
		<TELL
CTHE ,DETECTIVE " sees you carrying the body." CR>)>>

<GLOBAL JUNK-COUNT 0>
<GLOBAL JUNK-STRINGS <LTABLE
"\"Well, thank you, but I don't see what this has to do with the
case.\""
"\"Why are you trying to waste my time with this?\""
"\"If you keep this up, I'll have you up on 'obstruction of justice.'\""
"\"I refuse to be bothered with this idiocy! I have work to do!\"">>

<ROUTINE ITLL-WAIT ()
	 <TELL
"\"It will have to wait until " 'DUFFY " gets back from the lab.\"" CR>>

<ROUTINE CHECK-GLASS ()
	 <COND (<IN? ,DUFFY ,POLICE-LAB>
		<ITLL-WAIT>
		<RTRUE>)>
	 <COND (<NOT ,DETECTIVE-SEEN-GLASS?>
		<SETG DETECTIVE-SEEN-GLASS? T>
		<SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>)>
	 <COND (<OR <AND ,GLASS-ANALYZED?
			 <NOT ,PRSI>>
		    <AND ,GLASS-ANALYZED-FOR-PRINTS?
			 <EQUAL? ,PRSI ,GLOBAL-FINGERPRINTS>>>
		<TELL
"\"That's already been done.\"" CR>)
	       (ELSE
		<COND (<NOT ,GLASS-ANALYZED?>
		       <SETG GLASS-ANALYZED? T>
		       <SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>)>
		<TELL-ANALYZE ,GLASS>
		<COND (<EQUAL? ,PRSI ,GLOBAL-FINGERPRINTS>
		       <COND (<NOT ,GLASS-ANALYZED-FOR-PRINTS?>
			      <SETG GLASS-ANALYZED-FOR-PRINTS? T>
			      <COND (<NOT <FSET? ,GLASS ,TOUCHBIT>>
				     <SETG DETECTIVE-SEEN
					   <+ ,DETECTIVE-SEEN 1>>)>)>
		       <TELL " for " 'GLOBAL-FINGERPRINTS>)>
		<DUFFY-TO-LAB ,GLASS>)>>

<ROUTINE CHECK-JUNK (OBJ)
	 <COND (<IN? ,DUFFY ,POLICE-LAB>
		<ITLL-WAIT>
		<RTRUE>)>
	 <TELL-ANALYZE .OBJ>
	 <DUFFY-TO-LAB .OBJ>>

<ROUTINE TELL-ANALYZE (OBJ)
	 <TELL
"\"" 'DUFFY ", analyze " THE .OBJ>>

<ROUTINE DUFFY-TO-LAB (OBJ "AUX" GT)
	 <TELL "!\" " 'DUFFY " ">
	 <COND (<NOT <IN? ,DUFFY ,HERE>>
		<TELL "appears as if out of nowhere and ">)>
	 <TELL
"takes " THE .OBJ ". He seems to almost disappear. \"He's a fine
public servant,\" comments " THE ,DETECTIVE "." CR>
	 <SET GT <GET ,GOAL-TABLES ,DUFFY-C>>
	 <PUT .GT ,GOAL-ENABLE <>>
	 <PUT .GT ,ATTENTION 0>
	 <MOVE ,DUFFY ,POLICE-LAB>
	 <ENABLE <QUEUE I-DUFFY-RETURNS 20>>
	 <MOVE .OBJ ,POLICE-LAB>
	 <COND (<EQUAL? .OBJ ,GLASS>
		<SET OBJ ,GLASS-ANALYSIS>
		<COND (,GLASS-ANALYZED-FOR-PRINTS?
		       <COND (<FSET? ,GLASS ,TOUCHBIT>
			      <PUTP ,GLASS-ANALYSIS
				    ,P?TEXT
				    ,GLASS-ANALYSIS-Q>)
			     (ELSE
			      <FSET ,GLASS-ANALYSIS ,ALICIABIT>
			      <PUTP ,GLASS-ANALYSIS
				    ,P?TEXT
				    ,GLASS-ANALYSIS-P>)>)>)
	       (<EQUAL? .OBJ ,HAIR>
		<SET OBJ ,HAIR-ANALYSIS>)
	       (<EQUAL? .OBJ ,MASK>
		<SET OBJ ,MASK-ANALYSIS>)
	       (<EQUAL? .OBJ ,STAIN>
		<SET OBJ ,STAIN-ANALYSIS>)
	       (ELSE
		<SET OBJ ,NULL-ANALYSIS>)>
	 <MOVE .OBJ ,DUFFY>>

<ROUTINE I-DUFFY-RETURNS ("AUX" AOBJ GT PRIORITY FINAL)
	 <MOVE ,DUFFY <LOC ,DETECTIVE>>
	 <WHERE-UPDATE ,DUFFY <EQUAL? ,HERE <LOC ,DETECTIVE>>>
	 <SET GT <GET ,GOAL-TABLES ,DUFFY-C>>
	 <SET FINAL <GET .GT ,GOAL-F>>
	 <COND (<SET PRIORITY <GET .GT ,GOAL-QUEUED>>
		<ESTABLISH-GOAL ,DUFFY .PRIORITY>)>
	 <ESTABLISH-GOAL ,DUFFY .FINAL .PRIORITY>
	 <PUT .GT ,GOAL-ENABLE T>
	 <COND (<SET AOBJ <FIRST? ,DUFFY>>
		<COND (<IN? ,DETECTIVE ,HERE>
		       <MOVE .AOBJ ,PLAYER>
		       <TELL
'DUFFY " returns with the analysis. " CTHE ,DETECTIVE " reads it, then hands it
to you. It reads, omitting the irrelevant details:|
">
		       <TELL CR <GETP .AOBJ ,P?TEXT> CR>)
		      (ELSE
		       <FSET .AOBJ ,TOLD>
		       <MOVE .AOBJ ,DETECTIVE>
		       <RFALSE>)>)>>

<OBJECT HAIR-ANALYSIS
	(SYNONYM ANALYSIS)
	(ADJECTIVE HAIR)
	(DESC "hair analysis")
	(FLAGS TAKEBIT BURNBIT READBIT ALICIABIT)
	(TEXT
"\"This hair was found entangled in the mesh inner lining of a masquerade
costume. The hair is a woman's. It is dark brown, of medium length, and has
not recently been dyed. It includes the root, and thus was not cut but
pulled out or fell out.\"")>

<OBJECT MASK-ANALYSIS
	(SYNONYM ANALYSIS)
	(ADJECTIVE MASK)
	(DESC "mask analysis")
	(FLAGS TAKEBIT BURNBIT READBIT)
	(TEXT
"\"The mask was examined. There were small quantities of cosmetics
in positions consistent with the mask having recently been worn. Nothing
else of interest was discovered.\"")>

<OBJECT STAIN-ANALYSIS
	(SYNONYM ANALYSIS)
	(ADJECTIVE STAIN)
	(DESC "stain analysis")
	(FLAGS TAKEBIT BURNBIT READBIT)
	(TEXT
"\"The stain was analyzed and discovered to consist of residue of
an alcoholic beverage known as a 'Singapore Sling.' The cloth is otherwise
unremarkable.\"")>

<OBJECT NULL-ANALYSIS
	(SYNONYM ANALYSIS)
	(ADJECTIVE IRRELEVANT)
	(DESC "irrelevant analysis")
	(FLAGS TAKEBIT BURNBIT READBIT AN)
	(TEXT
"\"Nothing of relevance to the case was discovered.\"")>

<OBJECT GLASS-ANALYSIS
	(SYNONYM ANALYSIS)
	(ADJECTIVE BROKEN GLASS)
	(DESC "glass analysis")
	(FLAGS TAKEBIT BURNBIT READBIT)
	(TEXT
"\"The glass was analyzed and discovered to be coated with the residue of
an alcoholic beverage known as a 'Singapore Sling.' The glass itself, of
which this is only a large fragment, appears to have been shattered by an
impact.\"")>

<GLOBAL GLASS-ANALYSIS-P

"\"The glass was analyzed for fingerprints. This was difficult as the
surface was covered with the sugary residue of an alcoholic beverage
known as a 'Singapore Sling.' However, partial prints were recovered from
a dry area. These were compared with prints of Veronica Ashcroft taken
by Sergeant Duffy at the beginning of his investigation. It is our conclusion
that the prints on the glass are not those of Veronica Ashcroft.\"">

<GLOBAL GLASS-ANALYSIS-Q

"\"The glass was analyzed for fingerprints. This was difficult as the
surface was covered with the sugary residue of an alcoholic beverage
known as a 'Singapore Sling.' There are several badly smudged partial
prints. However, it was impossible to reach any conclusions based on them.
We believe that someone handled the fragment after the prints were
deposited, resulting in the smudging.\"">	

<OBJECT DETECTIVE-COAT
	(IN DETECTIVE)
	(DESC "trenchcoat")
	(SYNONYM TRENCHCOAT COAT)
	(FLAGS NDESCBIT)>

<ROUTINE TELL-RINGS ()
	 <TELL CTHE ,DETECTIVE " rings the doorbell, then stands
and waits." CR>>

<ROUTINE G-DETECTIVE (GARG "AUX" (L <LOC ,DETECTIVE>) (FLG <>))
	 <COND (<NOT .GARG> <IMOVEMENT ,DETECTIVE G-DETECTIVE>)
	       (<EQUAL? .GARG ,G-IMPATIENT>
		<TELL
CTHE ,DETECTIVE " says, \"If you'll excuse me, I have an investigation
to conduct.\"" CR>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<AND <EQUAL? ,TARGET ,PLAYER>
			    <SET FLG
				 <PLAYER-ARRESTED? ,DETECTIVE .GARG>>>
		       <RTRUE>)>
		<COND (<AND <IN? ,DETECTIVE ,HERE>
			    <LAB-RESULTS-TO-PLAYER .GARG>>
		       <SET GARG ,G-ALREADY>)>
		<COND (<IN? ,DETECTIVE ,PORCH>
		       <SETG NEW-ARRIVAL ,DETECTIVE>
		       <ESTABLISH-GOAL ,BUTLER ,HALL T>
		       <COND (<EQUAL? ,HERE ,PORCH>
			      <COND (<NOT ,PLAYER-HIDING>
				     <TELL
CTHE ,DETECTIVE " looks you over suspiciously. No one said that a costume
party was in progress. ">)>
			      <TELL-RINGS>)
			     (<EQUAL? ,HERE ,CIRCLE>
			      <TELL-RINGS>)
			     (<NOT <OUTSIDE? ,HERE>>
			      <TELL
CTHE ,DOORBELL " has just rung." CR>)>
		       ;<RTRUE>)
		      (<IN? ,DETECTIVE ,OFFICE>
		       <SETG DETECTIVE-BEEN-TO-OFFICE? T>)>
		<COND (<DETECTIVE-FINDS-BODY? .GARG> <SET FLG T>)
		      (<GO-AFTER-BODY? ,DETECTIVE>
		       <COND (<IN? ,DETECTIVE ,HERE>
			      <TELL
CTHE ,DETECTIVE " makes a quick examination of the vicinity." CR>)>)
		      (<AND <EQUAL? .GARG ,G-REACHED>
			    <IN? ,DETECTIVE ,HERE>>
		       <TELL
CTHE ,DETECTIVE " stops, looks carefully around, and then begins a detailed
examination of the vicinity." CR>)>
		<COND (<DETECTIVE-SEES-ROPE? .L>
		       <COND (<EQUAL? .L ,HERE>
			      <TELL
CTHE ,DETECTIVE " looks significantly at the rope. You catch a very suspicious
sidelong glance at your costume. You can almost hear the click of the lock
on a jail cell." CR>
			      <SET FLG T>)>)>
		<COND (<IN? ,DETECTIVE ,BALLROOM-8>
		       <I-START-ARREST>)>
		.FLG)
	       (<EQUAL? .GARG ,G-ENROUTE>
		<COND (<EQUAL? ,TARGET ,PLAYER>
		       <PLAYER-ARRESTED? ,DETECTIVE .GARG>)
		      (<DETECTIVE-FINDS-BODY? .GARG> <RTRUE>)
		      (<IN? ,DETECTIVE ,HERE>
		       <LAB-RESULTS-TO-PLAYER>)>)>>

<ROUTINE DETECTIVE-SEES-ROPE? (L)
	 <COND (<AND <EQUAL? <META-LOC ,ROPE> .L>
		     <NOT ,DETECTIVE-SEEN-ROPE?>>
		<SETG DETECTIVE-SEEN-ROPE? T>
		<SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>)>>

<ROUTINE DETECTIVE-FINDS-BODY? (GARG "AUX" (L <LOC ,DETECTIVE>)
				(LC <LOC ,CORPSE>) (BULLET? <>))
	 <COND (<AND .LC
		     <EQUAL? <META-LOC ,CORPSE> .L>
		     <NOT ,DETECTIVE-SEEN-CORPSE?>>
		<FSET ,DETECTIVE ,TOLD>
		<SETG DETECTIVE-SEEN-CORPSE? T>
		<SETG DETECTIVE-SEEN <+ ,DETECTIVE-SEEN 1>>
		<OPEN-HIDING-PLACE>
		<UNPRIORITIZE ,DETECTIVE>
		<GOALS? ,DETECTIVE <>>
		<ENABLE <QUEUE I-AMBULANCE 20>>
		<COND (<AND <IN? ,DETECTIVE ,OFFICE>
			    <EQUAL? <LOC ,BULLET> ,CORPSE ,OFFICE>>
		       <SET BULLET? T>
		       <FCLEAR ,BULLET ,INVISIBLE>
		       <MOVE ,BULLET ,DETECTIVE>
		       <SETG DETECTIVE-SEEN-BULLET? T>
		       <COND (<FSET? ,BULLET ,RMUNGBIT>
			      <SETG DETECTIVE-SEEN-BULLET-PRINTS? T>)>)>
		<COND (<AND <NOT <IN? ,DUFFY .L>>
			    <NOT <IN? ,DUFFY ,POLICE-LAB>>>
		       <ESTABLISH-GOAL ,DUFFY .L T>)>
		<COND (<EQUAL? .L ,HERE>
		       <TELL CTHE ,DETECTIVE " ">
		       <COND (<EQUAL? .GARG ,G-REACHED>
			      <TELL "arrives and ">)>
		       <COND (<OR <IN? ,CORPSE ,PLAYER>
				  <IN? .LC ,PLAYER>>
			      <SETG TARGET ,PLAYER>
			      <TELL
"stops short, seeing you carrying the body." CR>
			      <DETECTIVE-SEES-ROPE? .L>
			      <RETURN <PLAYER-ARRESTED? ,DETECTIVE>>)
			     (<NOT <IN? .LC ,ROOMS>>
			      <COND (<IN? ,DUFFY .L>
				     <TELL
"with a nod to " 'DUFFY ", takes over.">)
				    (T
				     <TELL-COMES-UPON .LC>
				     <COND (<NOT <EQUAL? .LC ,CHAIR>>
					    <TELL
"With an air of anticipation, " THE ,DETECTIVE " looks inside. ">)>
				     <TELL-BODY-THERE>)>)
			     (ELSE
			      <TELL
"immediately notices the body.">)>
		       <COND (.BULLET?
			      <TELL
" Seeing a glint of silver, the detective stoops down and carefully
retrieves " A ,BULLET ".">)>
		       <COND (<AND <NOT <EQUAL? .L ,OFFICE>>
				   <NOT <IN? ,DUFFY .L>>>
			      <TELL
" \"" 'DUFFY ", come here, I want you!\"">)>
		       <TELL
" As first priority, " THE ,DETECTIVE " checks out the corpse. While you
watch, it is efficiently examined, touched, looked at, looked under,
fingerprinted, and so on." CR>)>)>>

<ROUTINE OPEN-HIDING-PLACE ("AUX" (L <LOC ,CORPSE>))
	 <COND (<OR <EQUAL? .L ,HAMPER ,WINDOW-SEAT ,MERCEDES-TRUNK>
		    <EQUAL? .L ,BMW-TRUNK>>
		<FSET .L ,OPENBIT>
		<COND (<IN? ,PLAYER .L>
		       <MOVE ,PLAYER ,HERE>)>)>>

<ROUTINE I-START-ARREST ()
	 <COND (<AND <G? ,DETECTIVE-SEEN 4>
		     <NOT ,PLAYER-SEEN-WITH-BODY?>>
		<RFALSE>)
	       (<AND <OR ,DETECTIVE-SEEN-CORPSE?
			 ,DUFFY-SEEN-CORPSE?>
		     <NOT <IN? ,DUFFY ,POLICE-LAB>>>
		<SETG TARGET ,PLAYER>
		<STALK-PLAYER ,DETECTIVE>
		<STALK-PLAYER ,DUFFY>)
	       (ELSE
		<ENABLE <QUEUE I-START-ARREST 10>>)>
	 <RFALSE>>

<ROUTINE STALK-PLAYER (WHO)
	 <COND (<DIR-FROM ,HERE <LOC .WHO>>
		<MOVE .WHO ,HERE>
		<PLAYER-ARRESTED? .WHO ,G-REACHED>)
	       (ELSE
		<ESTABLISH-GOAL .WHO ,HERE>)>>

<ROUTINE LAB-RESULTS-TO-PLAYER ("OPTIONAL" (GARG ,G-ALREADY)
				"AUX" F N (FIRST T))
	 <SET F <FIRST? ,DETECTIVE>>
	 <REPEAT ()
		 <COND (<NOT .F>
			<RETURN <NOT .FIRST>>)>
		 <SET N <NEXT? .F>>
		 <COND (<FSET? .F ,TOLD>
			<FCLEAR .F ,TOLD>
			<MOVE .F ,PLAYER>
			<COND (.FIRST
			       <SET FIRST <>>
			       <TELL
CTHE ,DETECTIVE>
			       <COND (<EQUAL? .GARG ,G-REACHED>
				      <TELL " comes up to you and">)>
			       <TELL " interrupts.">)>
			<TELL CR
"\"">
			<COND (<EQUAL? .F ,NULL-ANALYSIS>
			       <TELL "analysis">)
			      (T
			       <TELL CTHE .F>)>
			<TELL
" is back from the lab. I thought you might be interested
in what it says.\" " CTHE ,DETECTIVE " hands it to you. It reads, omitting the
irrelevant details:|
" CR <GETP .F ,P?TEXT> CR>)>
		 <SET F .N>>>

<GLOBAL TARGET <>>

<ROUTINE TELL-ON-SCENE (WHO)
	 <TELL CD .WHO " arrives on the scene">>

<ROUTINE PLAYER-ARRESTED? (WHO "OPTIONAL" (GARG ,G-ALREADY))
	 <COND (<AND <G? ,DETECTIVE-SEEN 4>
		     <NOT ,PLAYER-SEEN-WITH-BODY?>>
		<SETG TARGET <>>
		<RFALSE>)
	       (<AND <EQUAL? .WHO ,DETECTIVE>
		     <IN? ,DETECTIVE ,HERE>>
		<COND (,DUFFY-SNARFED
		       <TELL-ON-SCENE ,DETECTIVE>
		       <TELL ", surveys the situation, and says
\"Good work, Sergeant!\" " CTHE ,DETECTIVE " eyes you with satisfaction.
\"You're under arrest for the murder of " 'VERONICA " Ashcroft.\" The
standard warnings are given. " 'DUFFY>)
		      (ELSE
		       <FSET ,PLAYER ,TOLD>
		       <TELL CTHE ,DETECTIVE>
		       <COND (<NOT <EQUAL? .GARG ,G-ALREADY>>
			      <TELL
" sees you, approaches warily, and">)>
		       <TELL
" grabs you firmly by the wrist, and with a practiced twist,
slips the cuffs on you. \"You're under arrest for the murder of " 'VERONICA "
Ashcroft.\" The standard warnings are given. " 'DUFFY " appears, as
though out of nowhere, and">)>
		<TELL " escorts you out to the waiting police car.
All your protests are ignored.|
|
In the subsequent trial, you are ">
		<COND (<OR ,PLAYER-FOLLOWED-VERONICA?
			   ,PLAYER-BEEN-TO-OFFICE?>
		       <TELL
"convicted of second degree murder. There was damning evidence, such as">)
		      (T
		       <TELL
"acquitted, in spite of">)>
		<TELL " the fact that">
		<COND (<AND ,DETECTIVE-BEEN-TO-OFFICE?
			    <NOT ,DETECTIVE-SEEN-ROPE?>>
		       <TELL " you attempted to hide the lariat which">)
		      (T
		       <TELL " your lariat">)>
		<TELL " was the murder weapon">
		<COND (,DETECTIVE-SEEN-BULLET?
		       <TELL
" and the bullet from your gunbelt">
		       <COND (,DETECTIVE-SEEN-BULLET-PRINTS?
			      <TELL
" (with both your " 'GLOBAL-FINGERPRINTS " and " 'VERONICA "'s on it)">)>
		       <TELL " was found near the
body">)>
		<TELL ".">
		<COND (,PLAYER-FOLLOWED-VERONICA?
		       <TELL
" Also, you were presumably the last person to see her alive, since you charged
off after her when she spilled her drink.">)>
		<COND (,PLAYER-SEEN-WITH-BODY?
		       <TELL
" Of course, you were seen moving the body around after the murder.">)
		      (,PLAYER-MOVED-BODY?
		       <TELL
" Stupidly, you moved the body after the murder.">)>
		<TELL " Finally, several guests testified against you as
a nosy and suspicious character." CR>
		<TELL "|
However, " THE ,DETECTIVE " and " 'DUFFY ", nagged by doubt, continue the
investigation on their own time. Their brilliant detective work unravels
the tangled mess behind the murder. You are released, and as you leave
jail, you can't help but think that if you had been able to figure out
what was going on that night, you might have won yourself a Pulitzer
Prize by now." CR>
		<FINISH>)
	       (<AND <EQUAL? .WHO ,DUFFY> <IN? ,DUFFY ,HERE>>
		<COND (<NOT ,DUFFY-SNARFED>
		       <FSET ,PLAYER ,TOLD>
		       <SETG DUFFY-SNARFED T>
		       <PUT <GET ,GOAL-TABLES ,PLAYER-C> ,GOAL-S <>>
		       <PUT <GET ,GOAL-TABLES ,DUFFY-C> ,GOAL-ENABLE <>>
		       <ESTABLISH-GOAL ,DETECTIVE ,HERE>
		       <TELL 'DUFFY>
		       <COND (,PLAYER-HIDING
			      <TELL " immediately penetrates the
concealment of " THE ,PLAYER-HIDING ". He">
			      <SETG PLAYER-HIDING <>>)>
		       <COND (<NOT <EQUAL? <LOC ,PLAYER> ,HERE>>
			      <MOVE ,PLAYER ,HERE>)>
		       <TELL
" grabs you with a grip of iron. \"" CTHE ,DETECTIVE " would like
a word with you,\" he says." CR>)
		      (<OR <NOT <VERB? TELL>> ,PRSI>
		       <TELL
'DUFFY " maintains his iron grip as you wait apprehensively for
the arrival of " THE ,DETECTIVE "." CR>)>)
	       (ELSE
		<I-START-ARREST>
		<RFALSE>)>>

<GLOBAL DUFFY-SNARFED <>>

\

<OBJECT GLOBAL-DUFFY
	(IN GLOBAL-OBJECTS)
	(DESC "Sergeant Duffy")
	(SYNONYM DUFFY)
	(ADJECTIVE SGT SERGEANT)
	(FLAGS TRANSBIT PERSON)
	(ACTION GLOBAL-PERSON-F)
	(CHARACTER 13)>

<OBJECT DUFFY
	(DESC "Sergeant Duffy")
	(SYNONYM DUFFY)
	(ADJECTIVE SGT SERGEANT)
	(ACTION DUFFY-F)
	(DESCFCN DUFFY-DESC-F)
	(FLAGS TRANSBIT PERSON)
	(CHARACTER 13)>

<ROOM POLICE-LAB
      (IN ROOMS)
      (DESC "Police Laboratory")>

<ROUTINE DUFFY-DESC-F ("OPTIONAL" (RARG <>))
	 <TELL 'DUFFY>
	 <COND (,DUFFY-SNARFED
		<TELL
" is here, his iron grip immobilizing you." CR>)
	       (<AND <IN? ,DUFFY ,OFFICE> ,LAST-FROB>
		<TELL
" is carefully checking over " THE ,LAST-FROB
		      ", making sure his boss has missed nothing." CR>)
	       (ELSE
		<TELL
" waits nearby, ready to spring into action to serve his superior
officer." CR>)>>

<ROUTINE DUFFY-F ()
	 <COND (<EQUAL? ,WINNER ,DUFFY>
		<COND (<AND <VERB? GIVE>
			    <EQUAL? ,PRSO ,DUFFY-COAT>
			    <EQUAL? ,PRSI ,BUTLER>>
		       <COND (<IN? ,BUTLER ,HERE>
			      <TELL
'DUFFY ", following the example of his boss, refuses to give up his
raincoat." CR>)>
		       <RTRUE>)
		      (<VERB? ANALYZE>
		       <TELL
"\"I perform analyses for " THE ,DETECTIVE ". If you want
something analyzed, that's how to do it.\"" CR>)
		      (<DONT-HANDLE?> <RFALSE>)
		      (ELSE
		       <TELL
'DUFFY " stands silently, intent upon his business, and ignores your
request. You realize that his devotion to duty is so strong that he
would be hard to distract." CR>)>)
	       (<VERB? PHONE>
		<PERFORM ,V?PHONE ,POLICE>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<TELL
'DUFFY " is of medium height, very non-descript, very attentive to
his boss, " THE ,DETECTIVE ". He is in uniform." CR>)
	       (<AND <VERB? ASK-ABOUT> <EQUAL? ,PRSO ,DUFFY>>
		<TELL
"\"You'd have to ask " THE ,DETECTIVE ". His opinions are mine.\"" CR>)
	       (<VERB? SHOW>
		<COND (<AND <EQUAL? ,PRSO ,CORPSE>
			    <EQUAL? ,PRSI ,DUFFY>>
		       <TELL
'DUFFY " approaches." CR>)
		      (T
		       <TELL
"\"Perhaps that would interest the detective.\"" CR>)>)
	       (<CAUGHT-WITH-BODY?>
		<SETG DUFFY-SEEN-CORPSE? T>
		<I-START-ARREST>
		<TELL
'DUFFY " sees you carrying the body." CR>)>>

<ROUTINE CAUGHT-WITH-BODY? ()
	 <AND <VERB? $DISCOVER>
	      <EQUAL? ,PRSO ,CORPSE>
	      <IN? ,CORPSE ,PLAYER>>>

<OBJECT DUFFY-COAT
	(IN DUFFY)
	(DESC "raincoat")
	(SYNONYM RAINCOAT COAT)
	(ADJECTIVE TRANSPARENT)
	(FLAGS NDESCBIT)>

<GLOBAL DUFFY-SEEN-CORPSE? <>>

<ROUTINE G-DUFFY (GARG "AUX" (FLG <>))
	 <COND (<NOT .GARG> <IMOVEMENT ,DUFFY G-DUFFY>)
	       (<AND <EQUAL? .GARG ,G-IMPATIENT>
		     <NOT ,DUFFY-SNARFED>>
		<TELL
'DUFFY " says, \"I have work to do. Goodbye.\"" CR>)
	       (<EQUAL? .GARG ,G-REACHED ,G-ALREADY>
		<COND (<AND <EQUAL? .GARG ,G-REACHED>
			    <IN? ,DUFFY ,HERE>>
		       <TELL-ON-SCENE ,DUFFY>
		       <TELL "." CR>
		       <SET FLG T>)>
		<COND (<DUFFY-FINDS-BODY? .GARG> <RTRUE>)
		      (ELSE .FLG)>)
	       (<EQUAL? .GARG ,G-ENROUTE>
		<DUFFY-FINDS-BODY? .GARG>)>>

<ROUTINE TELL-COMES-UPON (LC)
	 <TELL
"begins to search the room, and comes upon " THE .LC ". ">>

<ROUTINE TELL-BODY-THERE ()
	 <TELL
'VERONICA "'s body is there.">>

<ROUTINE DUFFY-FINDS-BODY? (GARG "AUX" (L <LOC ,DUFFY>) (LC <LOC ,CORPSE>))
	 <COND (<EQUAL? ,TARGET ,PLAYER>
		<PLAYER-ARRESTED? ,DUFFY .GARG>)
	       (<AND .LC
		     <EQUAL? <META-LOC ,CORPSE> .L>
		     <NOT ,DUFFY-SEEN-CORPSE?>>
		<FSET ,DUFFY ,TOLD>
		<OPEN-HIDING-PLACE>
		<SETG DUFFY-SEEN-CORPSE? T>
		<UNPRIORITIZE ,DUFFY>
		<GOALS? ,DUFFY <>>
		<COND (<NOT <IN? ,DETECTIVE .L>>
		       <ESTABLISH-GOAL ,DETECTIVE .L T>)>
		<COND (<EQUAL? .L ,HERE>
		       <COND (<OR <IN? ,CORPSE ,PLAYER>
				  <IN? .LC ,PLAYER>>
			      <I-START-ARREST>
			      <TELL
'DUFFY "'s eyes widen as he sees you brazenly carrying the corpse." CR>
			      <PLAYER-ARRESTED? ,DUFFY>
			      <RTRUE>)
			     (<NOT <IN? .LC ,ROOMS>>
			      <COND (<IN? ,DETECTIVE .L>
				     <TELL
"He begins to lend his assistance." CR>)
				    (T
				     <TELL 'DUFFY " ">
				     <TELL-COMES-UPON .LC>
				     <COND (<NOT <EQUAL? .LC ,CHAIR>>
					    <TELL
"He looks at it suspiciously for a moment, then looks inside. ">)>
				     <TELL "His eyes widen. ">
				     <TELL-BODY-THERE>
				     <CRLF>)>)
			     (ELSE
			      <COND (<EQUAL? .GARG ,G-REACHED>
				     <TELL "He immediately">)
				    (<TELL 'DUFFY " suddenly">)>
			      <TELL
" notices the body." CR>)>
		       <COND (<AND <NOT <EQUAL? .L ,OFFICE>>
				   <NOT <IN? ,DETECTIVE .L>>>
			      <TELL
"He blows a small police whistle several times. \"" 'VERONICA "'s
body is here!\" he yells." CR>)>
		       <TELL 'DUFFY>
		       <COND (<NOT ,DETECTIVE-SEEN-CORPSE?>
			      <TELL
" makes a preliminary examination of the corpse while
he waits for " THE ,DETECTIVE "." CR>)
			     (<IN? ,DETECTIVE .L>
			      <TELL
" examines the body, making a few comments to " THE ,DETECTIVE ",
who makes a few notes." CR>)
			     (ELSE
			      <TELL
" makes a few observations which he records in his notebook." CR>)>)>)
	       (.LC
		<GO-AFTER-BODY? ,DUFFY>
		<RFALSE>)>>

<ROUTINE GO-AFTER-BODY? (WHO)
	 <COND (<OR <NOT ,DETECTIVE-BEEN-TO-OFFICE?>
		    ,DETECTIVE-SEEN-CORPSE?
		    ,DUFFY-SEEN-CORPSE?
		    <LISTENING? .WHO>>
		<RFALSE>)
	       (<OR <FSET? ,CORPSE ,RMUNGBIT>
		    ,PLAYER-SEEN-WITH-BODY?
		    <PROB 25>>
		<FSET ,CORPSE ,RMUNGBIT>
		<ESTABLISH-GOAL .WHO <META-LOC ,CORPSE> T>
		<RTRUE>)>>

<ROUTINE I-POLICE-ARRIVE ()
	 <MOVE ,DETECTIVE ,CIRCLE>
	 <MOVE ,DUFFY ,CIRCLE>
	 <MOVE ,POLICE-CAR ,CIRCLE>
	 <ESTABLISH-GOAL ,DETECTIVE ,PORCH>
	 <ESTABLISH-GOAL ,DUFFY ,PORCH>
	 <COND (<EQUAL? ,HERE ,PORCH ,CIRCLE>
		<TELL
"Up the driveway speeds an unmarked police car with a detachable bubble
light blinking on its roof. It parks right in front of you
in the circle. The driver and a passenger emerge. The driver is wearing
a rain slicker under which you can see a uniform. The passenger is in
plain clothes, wearing a trenchcoat." CR>)
	       (ELSE
		<TELL
"You hear the sound of a police siren approaching. It stops." CR>)>>

<ROUTINE I-AMBULANCE ("AUX" (L <META-LOC ,CORPSE>))
	 <COND (<NOT ,DETECTIVE-BEEN-TO-OFFICE?>
		<NEW-SCRIPT ,DETECTIVE ,DETECTIVE-SCRIPT>
		<NEW-SCRIPT ,DUFFY ,DUFFY-SCRIPT>)
	       (T
		<GOALS? ,DETECTIVE T>
		<COND (<NOT <IN? ,DUFFY ,POLICE-LAB>>
		       <GOALS? ,DUFFY T>)>)>
	 <FCLEAR ,ROPE ,NDESCBIT>
	 <REMOVE ,CORPSE>
	 <COND (<OR <EQUAL? ,HERE .L>
		    <EQUAL? ,HERE ,CIRCLE ,PORCH ,HALL>>
		<TELL
"The ambulance has finally arrived, and the attendants remove the body on a
stretcher." CR>)>>

<OBJECT POLICE-CAR
	(DESC "police car")
	(SYNONYM CAR)
	(ADJECTIVE POLICE)
	(ACTION POLICE-CAR-F)
	(FLAGS LOCKED WINDOWBIT DOORBIT)>

<ROUTINE POLICE-CAR-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL
"You see the usual equipment that TV has led you to expect." CR>)>>

<OBJECT MASK
	(IN PLAYER)
	(DESC "western mask")
	(SYNONYM MASK)
	(ADJECTIVE MY COWBOY WESTERN)
	(ACTION MASK-F)
	(FLAGS WEARBIT TAKEBIT TRYTAKEBIT)>

<ROUTINE MASK-F ()
	 <COND (<VERB? TAKE-OFF>
		<COND (<FSET? ,PRSO ,WEARBIT>
		       <FCLEAR ,PRSO ,WEARBIT>
		       <TELL
"You remove your mask, revealing your smiling face and twinkling eyes." CR>)
		      (T
		       <TELL ,ITS-ALREADY "off." CR>)>)
	       (<VERB? WEAR>
		<COND (<FSET? ,PRSO ,WEARBIT>
		       <TELL ,ITS-ALREADY "on." CR>)
		      (T
		       <FSET ,PRSO ,WEARBIT>
		       <TELL "Okay." CR>)>)>>

<OBJECT SHEIK-COSTUME
	(IN MICHAEL)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE SHEIK MICHAEL)
	(DESC "sheik costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
        (FLAGS NDESCBIT)>

<OBJECT HAREM-COSTUME
	(IN ALICIA)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE HAREM ALICIA)
	(DESC "harem costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT BALLERINA-COSTUME
	(IN LINDA)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE BALLERINA LINDA)
	(DESC "ballerina costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT WEREWOLF-COSTUME
	(IN RICHARD)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE WEREWOLF RICHARD)
	(DESC "werewolf costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT HARLEQUIN-COSTUME
	(IN SEN-ASHER)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE HARLEQUIN SEN ASHER)
	(DESC "harlequin costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT EXPLORER-COSTUME
	(IN COL-MARSTON)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE EXPLORER HUNTER MARSTON)
	(DESC "explorer costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT ASTRONAUT-COSTUME
	(IN COCHRANE)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE ASTRONAUT COCHRANE)
	(DESC "astronaut costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT VAMPIRE-COSTUME
	(IN OSTMANN)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE VAMPIRE OSTMANN)
	(DESC "vampire costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<OBJECT GORILLA-COSTUME
	(IN BUTLER)
	(SYNONYM COSTUME MASK)
	(ADJECTIVE GORILLA BUTLER SMYTHE)
	(DESC "gorilla costume")
	(ACTION COSTUME-F)
	(GENERIC GENERIC-STUFF-F)
	(FLAGS NDESCBIT)>

<ROUTINE COSTUME-F ()
	 <COND (<VERB? EXAMINE>
		<PERFORM ,V?EXAMINE <LOC ,PRSO>>
		<RTRUE>)
	       (<VERB? TAKE LOOK-BEHIND LOOK-UNDER LOOK-INSIDE>
		<PERFORM ,V?UNMASK <LOC ,PRSO>>
		<RTRUE>)>>

"GENERICS: MASK, COSTUME, DOOR"

<ROUTINE GENERIC-STUFF-F (NAM)
	 <COND (<AND <EQUAL? .NAM ,W?COSTUME>
		     <EQUAL? <META-LOC ,FAIRY-COSTUME> ,HERE>>
		,FAIRY-COSTUME)
	       (<AND <EQUAL? .NAM ,W?MASK>
		     <EQUAL? <META-LOC ,FAIRY-MASK> ,HERE>>
		,FAIRY-MASK)
	       (T
		<TELL-SPECIFIC>
		,NOT-HERE-OBJECT)>>
