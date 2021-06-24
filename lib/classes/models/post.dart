class Post {
  final int no;
  final int? sticky;
  final int? closed;
  final String now;
  final String name;
  final String? sub;
  final String? com;
  final String filename;
  final String ext;
  final int w;
  final int h;
  final int tnW;
  final int tnH;
  final int tim;
  final int time;
  final String md5;
  final int fsize;
  final int resto;
  final String? capcode;
  final String? semanticUrl;
  final int? replies;
  final int? images;
  final int? uniqueIps;

  Post(
      {required this.no,
      this.sticky,
      this.closed,
      required this.now,
      required this.name,
      this.sub,
      this.com,
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
      this.capcode,
      this.semanticUrl,
      this.replies,
      this.images,
      this.uniqueIps});

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
