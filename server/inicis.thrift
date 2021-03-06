/**
 * The first thing to know about are types. The available types in Thrift are:
 *
 *  bool        Boolean, one byte
 *  i8 (byte)   Signed 8-bit integer
 *  i16         Signed 16-bit integer
 *  i32         Signed 32-bit integer
 *  i64         Signed 64-bit integer
 *  double      64-bit floating point value
 *  string      String
 *  binary      Blob (byte array)
 *  map<t1,t2>  Map from one type to another
 *  list<t1>    Ordered list of one type
 *  set<t1>     Set of unique elements of one type
 *
 * Did you also notice that Thrift supports C style comments?
 */

namespace php inicis

service Inicis {
  string getTimestamp()
  string makeSignature(1:string oid, 2:string price, 3:string timestamp)
  string makePaymentAproveSignature(1:string authToken, 2:string timestamp)
  string makeHash(1:string signKey)
  string getAuthenticationResult(1:map<string,string> data, 2:string url)
  string getMobileAuthenticationResult(1:string inipayhome, 2:string mid, 3:string p_rmesg1, 4:string p_tid, 5:string p_status, 6:string p_req_url, 7:string p_noti)
  string aes256_cbc_encrypt(1:string key, 2:string data, 3:string iv)
  string aes256_cbc_decrypt(1:string key, 2:string data, 3:string iv)
}
