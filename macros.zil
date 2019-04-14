<ZSTR-OFF>

"MACROS for M3
Copyright (c) 1984 Infocom, Inc.  All rights reserved."

<SETG C-ENABLED? 0>
<SETG C-ENABLED 1>
<SETG C-DISABLED 0>

<DEFMAC TELL ("ARGS" A)
	<FORM PROG ()
	      !<MAPF ,LIST
		     <FUNCTION ("AUX" E P O)
			  <COND (<EMPTY? .A> <MAPSTOP>)
				(<SET E <NTH .A 1>>
				 <SET A <REST .A>>)>
			  <COND (<TYPE? .E ATOM>
				 <COND (<OR <=? <SET P <SPNAME .E>>
						"CRLF">
					    <=? .P "CR">>
					<MAPRET '<CRLF>>)
				       ;(<=? .P "V">
					<MAPRET '<VPRINT>>)
				       (<EMPTY? .A>
					<ERROR INDICATOR-AT-END? .E>)
				       (ELSE
					<SET O <NTH .A 1>>
					<SET A <REST .A>>
					<COND (<OR <=? <SET P <SPNAME .E>>
						       "DESC">
						   <=? .P "D">
						   <=? .P "OBJ">
						   <=? .P "O">>
					       <MAPRET <FORM DPRINT .O>>)
					      (<=? .P "CD">
					       <MAPRET <FORM DPRINT .O T>>)
					      (<=? .P "HE/SHE">
					       <MAPRET
						 <FORM HE/SHE-PRINT .O>>)
					      (<=? .P "HIM/HER">
					       <MAPRET
						 <FORM HIM/HER-PRINT .O>>)
					      (<=? .P "HIS/HER">
					       <MAPRET
						 <FORM HIM/HER-PRINT .O T>>)
					      (<=? .P "THE">
					       <MAPRET
						 <FORM THE-PRINT .O>>)
					      (<=? .P "CTHE">
					       <MAPRET
						 <FORM THE-PRINT .O T>>)
					      (<OR <=? .P "A">
						   <=? .P "AN">>
					       <MAPRET <FORM PRINTA .O>>)
					      (<OR <=? .P "NUM">
						   <=? .P "N">>
					       <MAPRET <FORM PRINTN .O>>)
					      (<OR <=? .P "CHAR">
						   <=? .P "CHR">
						   <=? .P "C">>
					       <MAPRET <FORM PRINTC .O>>)
					      (ELSE
					       <MAPRET
						 <FORM PRINT
						       <FORM GETP .O .E>>>)>)>)
				(<TYPE? .E STRING ZSTRING>
				 <MAPRET <FORM PRINTI .E>>)
				(<AND <TYPE? .E FORM>
				      <==? <NTH .E 1> QUOTE>>
				 <MAPRET <FORM PRINTD <FORM GVAL <NTH .E 2>>>>)
				(<TYPE? .E FORM LVAL GVAL>
				 <MAPRET <FORM PRINT .E>>)
				(ELSE <ERROR UNKNOWN-TYPE .E>)>>>>>

<ROUTINE DPRINT (O "OPTIONAL" (CAP? <>) "AUX" S)
	 <COND (<FSET? .O ,THE>
		<COND (.CAP? <PRINTI "The ">)
		      (T <PRINTI "the ">)>)>
	 <COND (<SET S <GETP .O ,P?SDESC>>
		<PRINT .S>)
	       (ELSE <PRINTD .O>)>>

<ROUTINE THE-PRINT (O "OPTIONAL" (CAP? <>) "AUX" S)
	 <COND (<OR <FSET? .O ,THE>
		    <AND <NOT <FSET? .O ,PERSON>>
			 <NOT <FSET? .O ,FEMALE>>>>
		<COND (.CAP? <PRINTI "The ">)
		      (T <PRINTI "the ">)>)>
	 <COND (<SET S <GETP .O ,P?SDESC>>
		<PRINT .S>)
	       (ELSE <PRINTD .O>)>>

<ROUTINE HE/SHE-PRINT (O)
	 <COND (<NOT <FSET? .O ,PERSON>> <PRINTI "it">)
	       (<FSET? .O ,FEMALE> <PRINTI "she">)
	       (ELSE <PRINTI "he">)>>

<ROUTINE HIM/HER-PRINT (O "OPTIONAL" (POSSESSIVE? <>))
	 <COND (<NOT <FSET? .O ,PERSON>>
		<COND (.POSSESSIVE? <PRINTI "it's">)
		      (ELSE <PRINTI "it">)>)
	       (<FSET? .O ,FEMALE> <PRINTI "her">)
	       (.POSSESSIVE? <PRINTI "his">)
	       (ELSE <PRINTI "him">)>>

<ROUTINE PRINTA (O "AUX" S)
	 <COND (<FSET? .O ,THE> <PRINTI "the ">)
	       (<FSET? .O ,AN> <PRINTI "an ">)
	       (<NOT <FSET? .O ,PERSON>> <PRINTI "a ">)>
	 <COND (<SET S <GETP .O ,P?SDESC>>
		<PRINT .S>)
	       (ELSE <PRINTD .O>)>>

<DEFMAC VERB? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				     (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L
			     (<FORM GVAL <PARSE <STRING "V?" <SPNAME .ATM>>>>
			      !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSA !.L> !.O)>
		<SET L ()>>>

<DEFMAC RFATAL ()
	'<PROG () <PUSH 2> <RSTACK>>>

;<ROUTINE RANDOM-ELEMENT (FROB)
	 <GET .FROB <RANDOM <GET .FROB 0>>>>

<ROUTINE PICK-ONE (FROB
		   "AUX" (L <GET .FROB 0>) (CNT <GET .FROB 1>) RND MSG RFROB)
	 <SET L <- .L 1>>
	 <SET FROB <REST .FROB 2>>
	 <SET RFROB <REST .FROB <* .CNT 2>>>
	 <SET RND
	      <COND (<G? ,PRESENT-TIME 540>
		     <RANDOM <- .L .CNT>>)
		    (ELSE 1)>>
	 <SET MSG <GET .RFROB .RND>>
	 <PUT .RFROB .RND <GET .RFROB 1>>
	 <PUT .RFROB 1 .MSG>
	 <SET CNT <+ .CNT 1>>
	 <COND (<==? .CNT .L> <SET CNT 0>)>
	 <PUT .FROB 0 .CNT>
	 .MSG>

<ROUTINE PROB (BASE)
	 <AND <G? ,PRESENT-TIME 540>
	      <NOT <L? .BASE <RANDOM 100>>>>>

<DEFMAC ENABLE ('INT) <FORM PUT .INT ,C-ENABLED? 1>>

<DEFMAC DISABLE ('INT) <FORM PUT .INT ,C-ENABLED? 0>>

<DEFMAC ENABLED? ('INT) <FORM NOT <FORM EQUAL? <FORM GET .INT ,C-ENABLED?> 0>>>

<DEFMAC FLAMING? ('OBJ)
	<FORM AND <FORM FSET? .OBJ ',FLAMEBIT>
	          <FORM FSET? .OBJ ',ONBIT>>>

<DEFMAC OPENABLE? ('OBJ)
	<FORM OR <FORM FSET? .OBJ ',DOORBIT>
	         <FORM FSET? .OBJ ',CONTBIT>>> 

;"DO NOT MAKE THIS A MACRO"

<ROUTINE ABS (NUM)
	<COND (<L? .NUM 0> <- 0 .NUM>)
	      (T .NUM)>>

<ZSTR-ON>
