import 'dart:io';

const recreationPath = "C:\\Users\\testnow 720\\Desktop\\recreation";
const artFilePath = "C:\\Users\\testnow 720\\Desktop\\music_renamer\\art.jpeg";
const outPath = "H:\\new_music_yes"; // C:\\Users\\testnow 720\\Desktop\\recreation\\yeet

void main() async {
  final dir = Directory(recreationPath);
  if (!await dir.exists()) throw Exception("Recreation target directory does not exist");

  final artFile = File(artFilePath);
  if (!await artFile.exists()) throw Exception("Art image file path does not exist");

  final outDir = Directory(outPath);
  if (!await outDir.exists()) throw Exception("Out directory does not exist");

  final check = [];

  // TODO: REMOVE!
  for (final aaa in await Directory("C:\\Users\\testnow 720\\Desktop\\recreation\\music_yes").list().toList()) {
    final yes = aaa.uri.pathSegments.last;
    final yeName = yes.substring(RegExp(r".{5}").firstMatch(yes)!.end, RegExp(r".mp3$").firstMatch(yes)!.start).trim();
    check.add(yeName);
  }

  for (final file in await dir.list().toList()) {
    final name = file.uri.pathSegments.last;
    if (RegExp(r"\.webm$").firstMatch(name) == null) continue;

    final musicName = name.substring(RegExp(r".{30}").firstMatch(name)!.end, RegExp(r".{19}$").firstMatch(name)!.start).trim();

    String year;
    // Whether to put '2022' or '2024' in the year for the SotF soundtracks
    if (["Nudism", "Baby Follower", "Helob", "Rite of Wrath", "Forneus", "Gluttony of Cannibals", "Berith", "Temptation", "Crown Corrupted", "Writings of the Fanatic"].contains(musicName)) {
      year = "2024";
    } else {
      year = "2022";
    }
    print("Set $musicName's year to $year");

    // FIXME: THIS DEPENDS ON THE ORIGINAL LISTING OF DIR BEING IN NUMBERED ORDER!
    final res = await Process.start("ffmpeg", ["-hide_banner", "-i", file.path, "-vn", "-c:a", "mp3", "-metadata", "title=$musicName", "-metadata", "artist=River Boy", "-metadata", "album_artist=River Boy", "-metadata", "album=Cult of the Lamb Original Soundtrack", "-metadata", "date=$year", "-metadata", "track=${(!check.contains(musicName)) ? "" : "${check.indexOf(musicName)+1}"}", "-metadata", "composer=River Boy", "-y", "${outDir.path}.\\${(!check.contains(musicName)) ? "$musicName.mp3" : "${(check.indexOf(musicName)+1).toString().padLeft(2, "0")} - $musicName.mp3"}"]);
    res.stderr.forEach((list) {
      //print(String.fromCharCodes(list));
    });

    await res.exitCode;
    File middleFile = File("${outDir.path}.\\${(!check.contains(musicName)) ? "$musicName.mp3" : "${(check.indexOf(musicName)+1).toString().padLeft(2, "0")} - $musicName.mp3"}");
    final lastSeparator = middleFile.path.lastIndexOf(Platform.pathSeparator);
    final newPath = "${middleFile.path.substring(0, lastSeparator + 1)}${(!check.contains(musicName)) ? "${musicName}_tmp.mp3" : "${(check.indexOf(musicName)+1).toString().padLeft(2, "0")} - ${musicName}_tmp.mp3"}";
    middleFile = await middleFile.rename(newPath);

    final buh = await Process.start("ffmpeg", ["-hide_banner", "-i", middleFile.path, "-i", artFile.path, "-map_metadata", "0", "-map", "0", "-map", "1", "-c:v", "copy", /*"-id3v2_version", "3", "-metadata:s:v", "title=Album cover", "-metadata:s:v", "comment=Cover (front)",*/ "-y", "${outDir.path}.\\${(!check.contains(musicName)) ? "$musicName.mp3" : "${(check.indexOf(musicName)+1).toString().padLeft(2, "0")} - $musicName.mp3"}"]);
    buh.stderr.forEach((list) {
      //print(String.fromCharCodes(list));
    });
    if (await res.exitCode != 0 || await buh.exitCode != 0) throw Exception("An error occured while doing music $musicName");
    await middleFile.delete();

    // TODO: REMOVE!
    /*if (check.contains(musicName)) {
      check.remove(musicName);
    } else {
      print("stinkey alert : $musicName");
    }*/
  }
}
