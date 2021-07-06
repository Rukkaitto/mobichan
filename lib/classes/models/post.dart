class Post {
  final int no;
  final String now;
  final String? name;
  final int time;
  final int resto;
  final int? sticky;
  final int? closed;
  final String? sub;
  final String? com;
  final String? filename;
  final String? ext;
  final int? w;
  final int? h;
  final int? tnW;
  final int? tnH;
  final int? tim;
  final String? md5;
  final int? fsize;
  final String? capcode;
  final String? semanticUrl;
  final int? replies;
  final int? images;
  final int? uniqueIps;
  final String? trip;
  final int? lastModified;
  final String? board;

  Post({
    required this.no,
    required this.now,
    required this.name,
    required this.time,
    required this.resto,
    this.sticky,
    this.closed,
    this.sub,
    this.com,
    this.filename,
    this.ext,
    this.w,
    this.h,
    this.tnW,
    this.tnH,
    this.tim,
    this.md5,
    this.fsize,
    this.capcode,
    this.semanticUrl,
    this.replies,
    this.images,
    this.uniqueIps,
    this.trip,
    this.lastModified,
    this.board,
  });

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
      trip: json['trip'],
      lastModified: json['last_modified'],
      board: json['board'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'com': com,
      'sub': sub,
      'tim': tim,
      'no': no,
      'now': now,
      'name': name,
      'time': time,
      'resto': resto,
      'board': board,
    };
  }
}
