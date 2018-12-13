package org.springframework.base.system.utils;

/**
 * <p>Title: MongoDBUtil</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2018</p>
 * <p>Company: www.hanshow.com</p>
 *
 * @author guolin
 * @version 1.0
 * @date 2018-07-23 12:04
 */
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

import com.mongodb.*;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoIterable;
import com.mongodb.client.model.Filters;
import com.mongodb.client.result.DeleteResult;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;

public class MongoDBUtil {
    private static MongoClient mongoClient;

    public MongoDBUtil(String databaseConfigId) throws Exception {
        MongoClientURI uri = null;
        DBUtil db = new DBUtil();
        String sql = " select id, name, databaseType , databaseName, userName ,  password, port, ip ,url ,isdefault from  treesoft_config where id='" + databaseConfigId + "'";
        List<Map<String, Object>> list = db.executeQuery2(sql);
        Map<String, Object> map0 = (Map)list.get(0);
        String ip = "" + map0.get("ip");
        String port = "" + map0.get("port");
        String userName = "" + map0.get("userName");
        String databaseName = "" + map0.get("databaseName");
        String password = CryptoUtil.decode("" + map0.get("password"));
        if (password.indexOf("`") > 0) {
            password = password.split("`")[1];
        }

        (new StringBuilder()).append(map0.get("databaseType")).toString();
        if (userName.equals("")) {
            uri = new MongoClientURI("mongodb://" + ip + ":" + port);
        } else {
            uri = new MongoClientURI("mongodb://" + userName + ":" + password + "@" + ip + ":" + port + "/?authSource=" + databaseName + "&ssl=false");
        }

        mongoClient = new MongoClient(uri);
    }

    public MongoDatabase getDB(String dbName) {
        if (dbName != null && !"".equals(dbName)) {
            MongoDatabase database = mongoClient.getDatabase(dbName);
            return database;
        } else {
            return null;
        }
    }

    public MongoCollection<Document> getCollection(String dbName, String collName) {
        if (collName != null && !"".equals(collName)) {
            if (dbName != null && !"".equals(dbName)) {
                MongoCollection<Document> collection = mongoClient.getDatabase(dbName).getCollection(collName);
                return collection;
            } else {
                return null;
            }
        } else {
            return null;
        }
    }

    public List<String> getAllCollections(String dbName) {
        MongoIterable<String> colls = this.getDB(dbName).listCollectionNames();
        List<String> _list = new ArrayList();
        Iterator var5 = colls.iterator();

        while(var5.hasNext()) {
            String s = (String)var5.next();
            _list.add(s);
        }

        return _list;
    }

    public CommandResult getMongoStatus(String dbName) {
        CommandResult resultSet = mongoClient.getDB(dbName).getStats();
        return resultSet;
    }

    public CommandResult getMongoStatus2(String dbName) {
        CommandResult resultSet2 = mongoClient.getDB(dbName).command("serverStatus");
        return resultSet2;
    }

    public List<String> getAllDBNames() {
        MongoIterable<String> colls = mongoClient.listDatabaseNames();
        List<String> _list = new ArrayList();
        Iterator var4 = colls.iterator();

        while(var4.hasNext()) {
            String s = (String)var4.next();
            _list.add(s);
        }

        return _list;
    }

    public void dropDB(String dbName) {
        this.getDB(dbName).drop();
    }

    public Document runCommand(String dbName, String sql) {
        Bson arg0 = new BasicDBObject();
        Document doc = this.getDB(dbName).runCommand(arg0);
        return doc;
    }

    public Document findById(MongoCollection<Document> coll, String id) {
        ObjectId _idobj = null;

        try {
            _idobj = new ObjectId(id);
        } catch (Exception var5) {
            return null;
        }

        Document myDoc = (Document)coll.find(Filters.eq("_id", _idobj)).first();
        return myDoc;
    }

    public int getCount(MongoCollection<Document> coll) {
        int count = (int)coll.count();
        return count;
    }

    public MongoCursor<Document> find(MongoCollection<Document> coll, Bson filter) {
        return coll.find(filter).iterator();
    }

    public MongoCursor<Document> findByPageForMongoDB(MongoCollection<Document> coll, Bson filter, int pageNo, int pageSize) {
        return coll.find(filter).skip((pageNo - 1) * pageSize).limit(pageSize).iterator();
    }

    public int deleteById(MongoCollection<Document> coll, String id) {
        int count = 0;
        id = id.replace("ObjectId(\"", "").replace("\")", "");
        ObjectId _id = null;

        try {
            _id = new ObjectId(id);
        } catch (Exception var7) {
            return 0;
        }

        System.out.println("_id =" + _id);
        Bson filter = Filters.eq("_id", _id);
        DeleteResult deleteResult = coll.deleteOne(filter);
         count = (int)deleteResult.getDeletedCount();
        return count;
    }

    public Document updateById(MongoCollection<Document> coll, String id, Document newdoc) {
        ObjectId _idobj = null;
        id = id.replace("ObjectId(\"", "").replace("\")", "");
        _idobj = new ObjectId(id);
        Bson filter = Filters.eq("_id", _idobj);
        coll.updateOne(filter, new Document("$set", newdoc));
        return newdoc;
    }

    public void dropCollection(String databaseName, String tableName) {
        this.getDB(databaseName).getCollection(tableName).drop();
    }

    public void createCollection(String databaseName, String tableName) {
        this.getDB(databaseName).createCollection(tableName);
    }

    public void deleteCollection(String databaseName, String tableName) {
        this.getDB(databaseName).getCollection(tableName).drop();
    }

    public void close() {
        if (mongoClient != null) {
            mongoClient.close();
            mongoClient = null;
        }

    }

    public static void main(String[] args) {
        String dbName = "GC_MAP_DISPLAY_DB";
        String collName = "COMMUNITY_BJ";
        String sURI = String.format("mongodb://%s:%s@%s:%d/%s", "ctl", "liebe", "192.168.42.29", 27017, "test");
//        MongoClientURI uri = new MongoClientURI(sURI);
//        MongoClient mongoClient = new MongoClient(uri);
//        DB db = mongoClient.getDB("testdb");
//        System.out.println(db.getStats());
        System.out.println(        testConnection5(null,"test","192.168.42.29","27017","ctl","liebe"));
    }

    public static boolean testConnection5(String databaseType2, String databaseName2, String ip2, String port2, String user2, String pass2) {
        MongoClientURI uri = null;
        if ("".equals(user2)||null==user2) {
            uri = new MongoClientURI("mongodb://" + ip2 + ":" + port2);
        } else {
            uri = new MongoClientURI("mongodb://" + user2 + ":" + pass2 + "@" + ip2 + ":" + port2);
        }

        MongoClient mongoClient = new MongoClient(uri);
        MongoDatabase database = mongoClient.getDatabase(databaseName2);
        return database != null;
    }
}
