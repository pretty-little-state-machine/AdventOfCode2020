      * Advent of Code 2020
       IDENTIFICATION DIVISION.
       PROGRAM-ID. advent-of-code-day-03.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MAP ASSIGN TO './files/day_3_input.txt'
           ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD MAP
           LABEL RECORDS ARE OMITTED.
       01 INPUTRECORD PIC X(31).

       WORKING-STORAGE SECTION. 
       01  MAP-TOPO.
           05 FIELD PIC A(31).
       01  COORD-X PIC 9(02) VALUE 1.
       01  ITEM PIC X(01).
       01  TREES PIC 9(03) VALUE 0.
       01  FILE-STATUS PIC 9 VALUE 0.

       PROCEDURE DIVISION.
           OPEN INPUT MAP.
           PERFORM UNTIL FILE-STATUS = 1
              READ MAP INTO MAP-TOPO
                  AT END MOVE 1 TO FILE-STATUS
                  NOT AT END MOVE MAP-TOPO(COORD-X:1) TO ITEM
                     IF ITEM IS EQUAL TO "#"
                          ADD 1 TO TREES
                     END-IF
                     ADD 3 TO COORD-X
                     IF COORD-X IS GREATER THAN 31
                          SUBTRACT 31 FROM COORD-X
                     END-IF
              END-READ
           END-PERFORM.
           DISPLAY TREES
           CLOSE MAP.
           STOP RUN.
