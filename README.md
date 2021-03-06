# Fast University Preparation Assistant (FUPA)
FUPA is a quizzing program to assist both students and teachers. This project is created in **Intel x8086 assembly language** using _MASM_ assembler. This project is created with collaboration of three members namely Umer Ahmed, @M-AliTanveer and @T-Zaid as an university project of the third semester.

***

## What Inspired This Project?
The reason we created this program as a project is that the existing hand written methods of test preparations and quizzes do not meet or simulate the time constraints and uncomfortable environment for quizzing or test systems. During these periods of Coronavirus lockdowns, where every University and Institutions are closed. The use online tools to study and teach student proved to be a vital solution.
Although we see many online quiz assistants being used such as Google Forms, Koohat etc but they are not designed for this purpose and due to the lack of specific features required for online preparations and the fact that they are open platform, it is much easier for students to find a workaround or cheat methods for the quizzes.
FUPA seeks to overcome the hurdles of hand written assessment as well as existing online based quizzes by providing and simulating specific and new features which will aid students getting familiar with new modes of quiz.

## What is the workflow of FUPA Assistant ?
The workflow consists of two main sides of the program. Both sides make use of double clicking right in the console to preovide a semi-GUI input system.
- Teacher side.
- Student side.

### Teacher Side
The teacher side deals with the creation of new quizzes and collecting records of students who gave the test. The test can have 5 sections and 20 question per section at max. The test is protected with the code and a certain time period to access the quiz. A question can have 4 choices. Teacher can make unlimited code-protected quizzes with different time periods.

### Student side
The student side deals with the solving of quiz that was created by the teachers. Clicking-based methodology is implemented with the help of Windows API so the student just have to double click on one of the four choices. After the completion of quiz, student can view their marks as well as the answer solution. Answer solution will only be available after the time period of the quiz is over, so now, no student can access the question paper.

## Features
1. Code-protected quiz.
2. Instant marks evaluation.
3. Can enable/disable Negative marks.
4. Non-repetetive Randomized questions.
5. Answer sheet will only be activate at a specific time given by teacher.

### How to Execute:
The project is on an asm file. you will require MASM for assembling this. Visual studio 2019 is suggested. Execute the asm file inside an empty C++ project with MASM enabled from project properties.
