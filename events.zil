"EVENTS for M3
Copyright (C) 1984 Infocom, Inc.  All rights reserved."

"SCORE INDICATES HOURS / MOVES = MINUTES"

<GLOBAL SCORE 21>
<GLOBAL MOVES 0>

<GLOBAL PRESENT-TIME 540>		;"9 PM"

<ROUTINE INTRO ()
	 <TELL

"|
It's Halloween night. " 'VERONICA " Ashcroft and her mania for Halloween parties
are putting new twists on a 110-year-old tradition. It isn't a very nice
night for a party. The rain has
been pelting down since early morning, but the weather hasn't deterred
many guests. The ballroom at Ashcroft Farm is filled with oddly costumed
visitors. The rather ridiculous " 'COWBOY-COSTUME " you are wearing was the
only thing you could find at the costumer's on such short notice, but
it's out of place only for its relative sobriety and taste in this
crowd.|
" CR>>

<ROUTINE QUEUE-MAIN-EVENTS ()
	 <ENABLE <QUEUE I-RAIN-SLOWS <- 550 ,PRESENT-TIME>>>
	 <ENABLE <QUEUE I-RAIN-POURS <- 570 ,PRESENT-TIME>>>
	 <ENABLE <QUEUE I-RAIN-STOPS <- 630 ,PRESENT-TIME>>>
	 <ENABLE <QUEUE I-PARTY-OVER <- 750 ,PRESENT-TIME>>>
	 <ENABLE <QUEUE I-MUSIC 9>>
	 <SETG BAND-PLAYING? "Breathless">
	 <ENABLE <QUEUE I-WAVE-2 1>>
	 <ENABLE <QUEUE I-SPILL 2>>
	 <ENABLE <QUEUE I-GAME-OVER 720>>>

<ROUTINE I-WAVE ()
	 <CRLF>
	 <THIS-IS-S-HE ,MICHAEL>
	 <TELL

"A sheik, whom you can recognize as " 'MICHAEL " Wellman, and a fairy queen,
presumably " 'VERONICA " Ashcroft under her ornate mask, are discussing
something with a small group of guests near the fireplace. The sheik
notices you and waves for you to join them." CR>>

<ROUTINE I-WAVE-2 ()
	 <COND (<NOT <EQUAL? ,HERE ,BALLROOM-8>>
		<THIS-IS-S-HE ,MICHAEL>
		<CRLF>
		<TELL
"The sheik, seeing your reluctance to join them, shrugs his shoulders and
rejoins the conversation, a proprietary hand on the fairy's shoulder." CR>)>>

<ROUTINE I-SPILL ()
	 <SETG SLAPSTICK? <>>
	 <ESTABLISH-GOAL ,VERONICA ,OFFICE>
	 <MOVE ,GLASS ,BALLROOM-8>
	 <COND (<EQUAL? ,HERE ,BALLROOM-8>
		<THIS-IS-S-HE ,VERONICA>
		<CRLF>
		<TELL
'VERONICA " is discussing an upcoming horse show. One of her horses, named
\"Lurking Grue,\" will appear, and she describes its attributes in glowing
detail, muffled only by the ornate mask covering her face and slurred by the
effects of whatever liquid it is she has in a large glass. Emphasizing a
point, she waves the glass on high, but it's affected her coordination as well
as her speech. A bright red liquid punctuated with ice cubes pours out
of the glass and all over her dress. As might be expected, the gown is
white. She utters a word that silver-winged fairies aren't usually expected
to know, and throws the glass to the floor. " 'MICHAEL " reaches under his robes
and takes out a handkerchief, dabbing futilely at the stain. " 'VERONICA " snorts
in exasperation and pushes him away. \"I'm
going to go clean this up. You just stay here.\"" CR>)
	       (<IN-BALLROOM? ,PLAYER>
		<THIS-IS-S-HE ,VERONICA>
		<CRLF>
		<TELL
"Off near the fireplace, the sheik and the fairy queen are conversing
with a small group. The fairy is emphasizing some point when suddenly,
she manages to spill her drink on her gown. Her reaction is audible even
where you are standing, and she stalks off." CR>)>>

<ROUTINE IN-BALLROOM? (P)
	 <COND (<EQUAL? <GETP .P ,P?LINE> ,BALLROOM-LINE-C> <RTRUE>)
	       (<AND <LOC .P>
		     <EQUAL? <GETP <LOC .P> ,P?LINE> ,BALLROOM-LINE-C>>
		<RTRUE>)>>



"What happens at end..."

<ROUTINE TELL-MICHAELS-ALIBI ()
	 <TELL
" " 'MICHAEL " has a perfect alibi, as he was in the
Ballroom from the time " 'VERONICA " left to when the body was discovered.">>

<ROUTINE ARREST (PER "OPTIONAL" (HELPER <>) "AUX" FLG CORRECT?)
	 <COND (.HELPER
		<COND (<OR <EQUAL? .PER ,VERONICA ,DETECTIVE ,DUFFY>
			   <EQUAL? .HELPER ,VERONICA ,DETECTIVE ,DUFFY>>
		       <TELL
"\"Working on your insanity defense, eh?\"" CR>
		       <RTRUE>)
		      (<OR <AND <EQUAL? .HELPER ,ALICIA>
				<EQUAL? .PER ,MICHAEL>>
			   <AND <EQUAL? .PER ,ALICIA>
				<EQUAL? .HELPER ,MICHAEL>>>
		       <SET PER ,MICHAEL>
		       <SET HELPER ,ALICIA>
		       <COND (<L? ,DETECTIVE-SEEN ,DETECTIVE-CONVINCED>
			      <TELL
"\"I don't think there's enough evidence to obtain a conviction.">
			      <COND (<NOT ,DETECTIVE-SEEN-LIST?>
				     <TELL " What's Michael's motive?">)>
			      <COND (<AND <NOT ,DETECTIVE-SEEN-COAT?>
					  <NOT ,DETECTIVE-TOLD-ABOUT-RAIN?>>
				     <TELL " She wasn't even here until
after the murder.">)
				    (<OR <NOT ,DETECTIVE-SEEN-COAT?>
					 <NOT ,DETECTIVE-TOLD-ABOUT-RAIN?>>
				     <TELL
" If only the evidence was more conclusive that " 'ALICIA " was already here at
the time of the murder.">)>
			      <COND (<NOT ,GLASS-ANALYZED-FOR-PRINTS?>
				     <TELL " What part do you
think " 'ALICIA " played?">
				     <COND (<AND <NOT ,DETECTIVE-SEEN-HAIR?>
						 <NOT ,DETECTIVE-TOLD-ABOUT-RAIN?>
						 <NOT ,DETECTIVE-SEEN-COAT?>>
					    <TELL " She seems guiltless.">)>)>
			      <COND (<EQUAL? <+ ,DETECTIVE-SEEN 2>
					     ,DETECTIVE-CONVINCED>
				     <TELL " But I think we're very close.">)>
			      <TELL "\"" CR>)>)
		      (<AND ,DETECTIVE-SEEN-LIST?
			    <OR <EQUAL? .PER ,MICHAEL>
				<EQUAL? .HELPER ,COL-MARSTON>>
			    <OR <EQUAL? .HELPER ,MICHAEL>
				<EQUAL? .PER ,COL-MARSTON>>>
		       <TELL
"\"That's a plausible idea. Unfortunately, it doesn't tell us how the
murder was committed.">
		       <COND (<NOT ,GLASS-ANALYZED-FOR-PRINTS?>
			      <TELL-MICHAELS-ALIBI>)>
		       <TELL " Motive doesn't equal guilt.\"" CR>
		       <RTRUE>)
		      (ELSE
		       <TELL
CTHE ,DETECTIVE " ruminates a moment. \"It only casts suspicion back
on you to suggest such a thing.\"" CR>
		       <RTRUE>)>)>
	 <COND (.HELPER T)
	       (<EQUAL? .PER ,DUFFY ,DETECTIVE>
		<TELL "\"You think you're some sort of comedian, eh?\"" CR>
		<RTRUE>)
	       (<EQUAL? .PER ,MICHAEL>
		<COND (<NOT ,GLASS-ANALYZED-FOR-PRINTS?>
		       <TELL "\"No.">
		       <TELL-MICHAELS-ALIBI>
		       <TELL "\"" CR>
		       <RTRUE>)
		      (,DETECTIVE-SEEN-LIST?
		       <COND (<L? ,DETECTIVE-SEEN ,DETECTIVE-CONVINCED>
			      <TELL
"\"You may be right, but while he may have been in with " 'COL-MARSTON ", that
doesn't make him guilty of murder.\"" CR>)
			     (ELSE
			      <TELL
"\"He couldn't have done it by himself.\"" CR>)>)
		      (T
		       <TELL
"\"You've produced no evidence he did it. Do you merely dislike him?\"" CR>
		       <RTRUE>)>)
	       (<EQUAL? .PER ,ALICIA>
		<COND (<AND <NOT ,GLASS-ANALYZED-FOR-PRINTS?>
			    <NOT ,DETECTIVE-SEEN-COAT?>
			    <NOT ,DETECTIVE-SEEN-HAIR?>>
		       <TELL
"\"She wasn't even in the house when the murder was committed. I don't
buy it.\"" CR>)
		      (ELSE
		       <TELL
"\"I agree that she must have been involved, but it seems unlikely she
did it by herself. For one thing, what's her motive?\"" CR>)>) 
	       (<EQUAL? .PER ,SEN-ASHER>
		<TELL
"\"He was in the next room, it's true, but what motive did he have?
How did he do it?\"" CR>
		<RTRUE>)
	       (<EQUAL? .PER ,COCHRANE>
		<COND (,DETECTIVE-SEEN-AGREEMENT?
		       <COND (,DETECTIVE-SEEN-CARD?
			      <TELL
"\"The combination of the threat in that " 'CARD " and his anger
over the sale of the farm certainly present a strong circumstantial
case, at least as far as motive goes, but there is no direct evidence.\"" CR>)
			     (ELSE
			      <TELL
"\"It's clear he felt aggrieved by her behavior regarding the sale of
the farm, but murder? He seems like a mostly harmless drunk to me.\"" CR>)>)
		      (,DETECTIVE-SEEN-CARD?
		       <TELL
"\"That card certainly looks like a veiled threat to me, but what does it
refer to?\"" CR>)
		      (ELSE
		       <TELL
"\"Just because he's a boor doesn't make him guilty.\"" CR>
		       <RTRUE>)>)
	       (<EQUAL? .PER ,BUTLER>
		<TELL
"\"I suppose you think the butler always does it?">
		<COND (,DETECTIVE-SEEN-AGREEMENT?
		       <TELL
" Even if he knew about the sale of the farm, I don't see
any likelihood he could have done it.">)>
		<TELL "\"" CR>
		<RTRUE>)
	       (<EQUAL? .PER ,RICHARD>
		<TELL
"\"If everyone who hated a relative was guilty of murder, we'd have to
build a lot more prisons.\"" CR>
		<RTRUE>)
	       (<EQUAL? .PER ,COL-MARSTON>
		<COND (<OR ,DETECTIVE-SEEN-TRUST-DOCUMENTS?
			   ,DETECTIVE-SEEN-LIST?>
		       <TELL
"\"You've certainly shown a pattern of theft on his part, which may
well establish a motive, but what about the method and opportunity?
Theft for sure, but we're looking at murder here.\"" CR>)
		      (ELSE
		       <TELL "\"I don't see it, where's the motive?\"" CR>
		       <RTRUE>)>)
	       (ELSE
		<TELL
"\"Aside from motive, method, and opportunity, you seem to have a
perfect case.\"" CR>
		<RTRUE>)>
	 <SET CORRECT?
	      <AND <EQUAL? .PER ,MICHAEL>
		   <EQUAL? .HELPER ,ALICIA>>>
	 <COND (<AND .CORRECT?
		     ,FLEEING?
		     <OUTSIDE? <LOC ,MICHAEL>>
		     <NOT <EQUAL? ,HERE <LOC ,MICHAEL> <LOC ,ALICIA>>>>
		<MOVE ,DUFFY ,HERE>
		<ESTABLISH-GOAL ,DUFFY ,HERE>
		<TELL
'DUFFY " runs up, out of breath. \"I can't find them anywhere!\"" CR>)
	       (ELSE
		<DUFFY-PERFORMS-ARREST .PER .HELPER>
		<CASE-OVER .CORRECT?>)>
	 <RTRUE>>

<ROUTINE TELL-ONE-HERE-ONE-NOT (INHERE NOTHERE)
	 <TELL
'DUFFY " appears with " D .NOTHERE " in tow.">
	 <DUFFY-HANDCUFFS .INHERE>>

<ROUTINE TELL-ALL-HERE (PER "OPTIONAL" (HELPER <>))
	 <TELL
'DUFFY " appears with a solemn look.">
	 <DUFFY-HANDCUFFS .PER .HELPER>>

<ROUTINE TELL-NONE-HERE (PER "OPTIONAL" (HELPER <>))
	 <TELL
'DUFFY " seems to read your thoughts, as he appears with " D .PER>
	 <COND (.HELPER
		<TELL
" and " D .HELPER>)>
	 <TELL " in handcuffs.">>

<ROUTINE DUFFY-HANDCUFFS (PER "OPTIONAL" (HELPER <>))
	 <TELL " He puts handcuffs on the wrists of ">
	 <COND (.HELPER <TELL "both ">)>
	 <TELL D .PER>
	 <COND (.HELPER <TELL " and " D .HELPER>)>
	 <TELL ", who stand">
	 <COND (<NOT .HELPER> <TELL "s">)>
	 <TELL " stiff and quiet.">>

<ROUTINE DUFFY-PERFORMS-ARREST (PER HELPER)
	 <CRLF>
	 <COND (,MICHAEL-DEAD?
		<TELL-ALL-HERE ,ALICIA>
		<TELL " \"" ,AMBULANCE-COMING ",\" he tells her.">)
	       (.HELPER
		<COND (<AND <IN? .HELPER ,HERE>
			    <IN? .PER ,HERE>>
		       <TELL-ALL-HERE .PER .HELPER>)
		      (<IN? .HELPER ,HERE>
		       <TELL-ONE-HERE-ONE-NOT .HELPER .PER>)
		      (<IN? .PER ,HERE>
		       <TELL-ONE-HERE-ONE-NOT .PER .HELPER>)
		      (T
		       <TELL-NONE-HERE .PER .HELPER>)>)
	      (<EQUAL? ,HERE <META-LOC .PER>>
	       <TELL-ALL-HERE .PER>)
	      (T
	       <TELL-NONE-HERE .PER>)>
	 <TELL
" \"Let's not have any trouble, now,\" says " 'DUFFY ", in his unique way.
They head for the driveway, where a police car waits with engine
purring." CR>>

<ROUTINE CASE-OVER (CORRECT?)
	 <CRLF>
	 <COND (<AND .CORRECT? <==? ,DETECTIVE-SEEN ,DETECTIVE-CONVINCED>>
		<COND (,MICHAEL-DEAD?
		       <TELL
"Well, they got " 'ALICIA ", but not " 'MICHAEL ". He's beyond the reach of justice
now. Too bad you didn't figure it all out sooner.">)
		      (ELSE
		       <TELL
"Congratulations! Your testimony as star witness for the prosecution
secures the conviction of " 'MICHAEL " for the first degree murder of his wife,
and of " 'ALICIA " as his accomplice. Not only are they sent to prison with the
proverbial key thrown away, but " 'COL-MARSTON " is convicted in a parallel
case of embezzlement and grand theft for his role in the
milking of the family Trust.|
|
Best of all, your syndicated twelve-part story of the tangled plot and
its aftermath wins the Pulitzer Prize, and the book is number one on the
bestseller lists for 42 weeks! (Not to mention the movie and book club
sales.)|
|
As your book explains, the murder was triggered by " 'VERONICA "'s desire to
sell the farm and move to a more rural area. Even with the proceeds of
the sale, still more funds from the family Trust would have been required
to purchase the new property and build on it. " 'MICHAEL " and " 'COL-MARSTON "
were alarmed, as they had been milking the Trust by investing in dummy
corporations under their control. After a time, " 'VERONICA " grew suspicious
and had the Trust's dealings investigated. She expected that " 'COL-MARSTON "
would be implicated, but was surprised to find that " 'MICHAEL " was an equal
partner in the scheme. For " 'MICHAEL ", time was running out. He wanted out of
the marriage, but not the Ashcroft fortune, and enlisted " 'ALICIA "'s help in
the bizarre scheme. " 'ALICIA " would impersonate the murdered " 'VERONICA " to
establish an alibi. Your appearance on the scene as an old friend suggested
another red herring. A few pieces of evidence planted, and you might be
framed. Fortunately for all but the plotters, the plans were for naught.">)>)
	       (ELSE
		<TELL
,TOO-BAD "your testimony fails to convince the jury, for precisely
the reasons outlined by " THE ,DETECTIVE " before the arrest. Your editor
demotes you to covering flower shows and computer software conventions.
As a final blow, when " THE ,DETECTIVE " solves the case and makes the
arrest, you realize how simple it all should have been.">)>
	 <CRLF>
	 <FINISH>>

<ROUTINE FINISH ("AUX" Y)
	 <TELL "|
The story has come to an end.|
">
	<REPEAT ()
		<TELL "|
Would you like to start over from scratch or restore a saved position?">
		<COND (<NOT <SET Y <YES? T>>> <QUIT>)
		      (<EQUAL? .Y ,M-FATAL>
		       <V-RESTORE>)
		      (ELSE <RESTART>)>>>

<ROUTINE I-PARTY-OVER ("AUX" STR)
	 <SETG OVER-COUNT <+ ,OVER-COUNT 1>>
	 <COND (<SET STR <GET ,OVER-TABLE ,OVER-COUNT>>
		<QUEUE I-PARTY-OVER <+ 10 <RANDOM 10>>>)
	       (ELSE
		<SETG OFFICE-EXPEDITION? T>
		<COND (<NOT ,FLEEING?>
		       <ESTABLISH-GOAL ,MICHAEL ,BALLROOM-9>
		       <ESTABLISH-GOAL ,ALICIA ,BALLROOM-9>)>
		<ESTABLISH-GOAL ,RICHARD ,BALLROOM-9>
		<ESTABLISH-GOAL ,LINDA ,BALLROOM-9>
		<ESTABLISH-GOAL ,COL-MARSTON ,BALLROOM-9>
		<ESTABLISH-GOAL ,SEN-ASHER ,BALLROOM-9>
		<ESTABLISH-GOAL ,COCHRANE ,BALLROOM-9>
		<ESTABLISH-GOAL ,OSTMANN ,BALLROOM-9>
		<ESTABLISH-GOAL ,BUTLER ,BALLROOM-9>
		<ESTABLISH-GOAL ,DETECTIVE ,BALLROOM-9>
		<ESTABLISH-GOAL ,DUFFY ,BALLROOM-9>
		<SETG ON-DANCE-FLOOR? <>>
		<SETG PARTY-OVER T>)>
	 <COND (<OR <IN-BALLROOM? ,PLAYER>
		    <EQUAL? ,HERE ,HALLWAY-12 ,HALLWAY-11 ,HALLWAY-10>
		    <EQUAL? ,HERE ,HALLWAY-9 ,HALL>>
		<COND (.STR <TELL .STR CR>)
		      (ELSE
		       <TELL
"The last of the guests has left. No one is left but the suspects">
		       <COND (<LOC ,CORPSE>
			      <TELL" and the victim">)>
		       <TELL "." CR>)>)>>

<GLOBAL PARTY-OVER <>>
<GLOBAL OVER-COUNT 0>

<GLOBAL OVER-TABLE <LTABLE
"Guests are starting to leave."
"Some guests get their coats and depart."
"Most of the guests have left now. A few more are tossing down the last
of their drinks as they depart."
"A few stragglers continue their exhausted revelry, but the party is
clearly over."
<>>>

<ROUTINE DISCOVER-BODY (LISTENER "AUX" OW (L <LOC .LISTENER>))
	 <COND (<AND <EQUAL? <META-LOC ,CORPSE> .L>
		     <OR <IN? ,CORPSE .L>
			 <FSET? <LOC ,CORPSE> ,OPENBIT>
			 <FSET? <LOC ,CORPSE> ,PERSON>>>
		<SET OW ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?$DISCOVER ,CORPSE .LISTENER>
		<SETG WINNER .OW>)>>

<ROUTINE MURDER-TELL (LISTENER TELLER "AUX" OW)
	 <SET OW ,WINNER>
	 <COND (<EQUAL? ,PLAYER .TELLER>
		<DISCOVER-BODY .LISTENER>)>
	 <COND (<EQUAL? ,PLAYER .TELLER>
		<RFALSE>)
	       (<NOT <FSET? .LISTENER ,TOLD>>
		%<DEBUG-CODE
		  <COND (,GOSSIP
			 <TELL
"[" CD .TELLER " tells " D .LISTENER " in " D <LOC .TELLER> ".]" CR>)>>
		<COND (<EQUAL? .LISTENER ,PLAYER>
		       <COND (,PLAYER-HIDING <RFALSE>)
			     (<EQUAL? .TELLER ,MICHAEL>
			      <TELL
'MICHAEL " notices you. He looks very distraught, almost in shock.
\"" 'VERONICA "'s been murdered!\" he says. He chokes back a sob as a
tremor travels through his body." CR>)
			     (ELSE
			      <TELL
CD .TELLER " notices you and approaches. ">
			      <COND (<EQUAL? .TELLER ,DETECTIVE ,DUFFY>
				     <TELL
"\"There has been a murder. " 'VERONICA " Ashcroft has been killed. I
must warn you that everyone here is a suspect, and you aren't to leave
the premises without permission.\"" CR>)
				    (T
				     <TELL
"\"Did you hear?\" "
HE/SHE .TELLER " says quietly. \"Someone has murdered " 'VERONICA "!
They found the body, she was strangled. The office was ransacked!
Someone said it was a prowler, but no one's been caught yet.\"" CR>)>)>)
		      (ELSE
		       <SETG WINNER .TELLER>
		       <PERFORM ,V?$REVEAL ,GLOBAL-MURDER .LISTENER>
		       <SETG WINNER .OW>)>
		<FSET .LISTENER ,TOLD>)>>

<ROUTINE I-GAME-OVER ()
	 <TELL "Sorry, you have missed the morning edition deadline." CR>
	 <FINISH>>
