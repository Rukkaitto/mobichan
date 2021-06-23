class Post {
  late int no;
  late int sticky;
  late int closed;
  late String now;
  late String name;
  late String sub;
  late String com;
  late String filename;
  late String ext;
  late int w;
  late int h;
  late int tnW;
  late int tnH;
  late int tim;
  late int time;
  late String md5;
  late int fsize;
  late int resto;
  late String capcode;
  late String semanticUrl;
  late int replies;
  late int images;
  late int uniqueIps;

  Post(
      {required this.no,
      required this.sticky,
      required this.closed,
      required this.now,
      required this.name,
      required this.sub,
      required this.com,
      required this.filename,
      required this.ext,
      required this.w,
      required this.h,
      required this.tnW,
      required this.tnH,
      required this.tim,
      required this.time,
      required this.md5,
      required this.fsize,
      required this.resto,
      required this.capcode,
      required this.semanticUrl,
      required this.replies,
      required this.images,
      required this.uniqueIps});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      no: json['no'],
      sticky: json['sticky'],
      closed: json['closed'],
      now: json['now'],
      name: json['name'],
      sub: json['sub'],
      com: json['com'],
      filename: json['filename'],
      ext: json['ext'],
      w: json['w'],
      h: json['h'],
      tnW: json['tn_w'],
      tnH: json['tn_h'],
      tim: json['tim'],
      time: json['time'],
      md5: json['md5'],
      fsize: json['fsize'],
      resto: json['resto'],
      capcode: json['capcode'],
      semanticUrl: json['semantic_url'],
      replies: json['replies'],
      images: json['images'],
      uniqueIps: json['unique_ips'],
    );
  }
}
