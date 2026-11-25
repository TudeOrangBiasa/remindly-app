# Brief: Remindly (college assignments, offline, no account)

Read e2e/AGENT_BRIEF.md first: its tools, rules and final report all apply.
Only the goal changes.

Remindly records college assignments and deadlines. Tables: courses
(name, lecturer, day) and tasks (course, title, description, deadline,
priority Rendah Sedang Tinggi, done flag). No login, everything local.

As your persona, do all of this in order:

1. Add a course named for your studies. Try adding the same name again.
   The app must refuse with a reason.
2. Add a task for that course with tomorrow as deadline and priority
   Tinggi. Try an empty title and a past deadline. Both must be refused.
3. Mark the task done with its checkbox. Leave the app and come back.
   It must still be done.
4. Walk the filters Semua, Belum Selesai, Selesai, Terlambat. Order must
   run from the nearest deadline.
5. Make a task due tomorrow: expect an orange H-1 badge. Make an undone
   task due yesterday: expect a red badge.
6. Open the course detail. The done count must be right.
7. Try deleting the course while it still has tasks. The app must refuse
   with a reason. Delete the tasks first, then the course asks for
   confirmation.
8. Kill the app fully and relaunch. Data must still be there.
9. Report every deviation as a bug with steps and screenshots.
