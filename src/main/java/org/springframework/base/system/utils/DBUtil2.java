package org.springframework.base.system.utils;

/**
 * <p>Title: DBUtil2</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2018</p>
 * <p>Company: www.hanshow.com</p>
 *
 * @author guolin
 * @version 1.0
 * @date 2018-07-21 19:17
 */
import com.ctl.utils.ConfigUtils;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoIterable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DBUtil2 {
    static Logger logger = LoggerFactory.getLogger(DBUtil2.class);

    private static String databaseType = "MySql";
    private static String driver = ConfigUtils.getType("jdbc.mysql.driver");
    private static String databaseName = "test";
    private static String url;
    private static String userName;
    private static String password;
    private static String port;
    private static String ip;

    static {
        url = ConfigUtils.getType("jdbc.mysql.url");
        userName = ConfigUtils.getType("jdbc.mysql.username");
        password = ConfigUtils.getType("jdbc.mysql.password");
        port = ConfigUtils.getType("jdbc.mysql.port");
        ip = ConfigUtils.getType("jdbc.mysql.ip");
    }

    public DBUtil2(String dbName, String databaseConfigId) {
        DBUtil db = new DBUtil();
        String sql = " select id, name, databaseType , databaseName, userName ,  password, port, ip ,url ,isdefault from  treesoft_config where id='" + databaseConfigId + "'";
        List<Map<String, Object>> list = db.executeQuery2(sql);
        Map<String, Object> map0 = (Map)list.get(0);
        String ip = "" + map0.get("ip");
        String port = "" + map0.get("port");
        String userName = "" + map0.get("userName");
        String password = CryptoUtil.decode("" + map0.get("password"));
        if (password.indexOf("`") > 0) {
            password = password.split("`")[1];
        }

        String databaseType = "" + map0.get("databaseType");
        if (databaseType.equals("MySql")) {
            driver = "com.mysql.cj.jdbc.Driver";
            url = "jdbc:mysql://" + ip + ":" + port + "/" + dbName + "?characterEncoding=utf8&tinyInt1isBit=false&zeroDateTimeBehavior=convertToNull&transformedBitIsBoolean=true&useSSL=false";
        }

        if (databaseType.equals("MariaDB")) {
            driver = "com.mysql.jdbc.Driver";
            url = "jdbc:mysql://" + ip + ":" + port + "/" + dbName + "?characterEncoding=utf8&tinyInt1isBit=false&zeroDateTimeBehavior=convertToNull&transformedBitIsBoolean=true";
        }

        if (databaseType.equals("Oracle")) {
            driver = "oracle.jdbc.driver.OracleDriver";
            url = "jdbc:oracle:thin:@" + ip + ":" + port + ":" + dbName;
        }

        if (databaseType.equals("PostgreSQL")) {
            driver = "org.postgresql.Driver";
            url = "jdbc:postgresql://" + ip + ":" + port + "/" + dbName;
        }

        if (databaseType.equals("MSSQL")) {
            driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
            url = "jdbc:sqlserver://" + ip + ":" + port + ";database=" + dbName;
        }

        DBUtil2.userName = userName;
        DBUtil2.password = password;
    }

    public static final synchronized Connection getConnection() {
        try {
            Class.forName(driver);
            Connection conn = DriverManager.getConnection(url, userName, password);
            return conn;
        } catch (Exception var1) {
            logger.error("getConnection",var1);
            return null;
        }
    }

    public static boolean testConnection(String databaseType2, String databaseName2, String ip2, String port2, String user2, String pass2) {
        try {
            String url2 = "";
            if (databaseType2.equals("MySql")) {
                Class.forName("com.mysql.jdbc.Driver");
                url2 = "jdbc:mysql://" + ip2 + ":" + port2 + "/" + databaseName2 + "?characterEncoding=utf8&useSSL=false";
            }

            if (databaseType2.equals("MariaDB")) {
                Class.forName("com.mysql.jdbc.Driver");
                url2 = "jdbc:mysql://" + ip2 + ":" + port2 + "/" + databaseName2 + "?characterEncoding=utf8";
            }

            if (databaseType2.equals("Oracle")) {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                url2 = "jdbc:oracle:thin:@" + ip2 + ":" + port2 + ":" + databaseName2;
            }

            if (databaseType2.equals("PostgreSQL")) {
                Class.forName("org.postgresql.Driver");
                url2 = "jdbc:postgresql://" + ip2 + ":" + port2 + "/" + databaseName2;
            }

            if (databaseType2.equals("MSSQL")) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                url2 = "jdbc:sqlserver://" + ip2 + ":" + port2 + ";database=" + databaseName2;
            }


            if (databaseType2.equals("MongoDB")) {
                MongoClientURI uri;
                if (user2.equals("")) {
                    uri = new MongoClientURI("mongodb://" + ip2 + ":" + port2);
                } else {
                    uri = new MongoClientURI("mongodb://" + user2 + ":" + pass2 + "@" + ip2 + ":" + port2 + "/?authSource=" + databaseName2 + "&ssl=false");
                }

                MongoClient mongoClient = new MongoClient(uri);
                MongoDatabase database = mongoClient.getDatabase(databaseName2);
                MongoIterable<String> colls = database.listCollectionNames();
                if (colls.iterator().hasNext()) {
                    uri = null;
                    mongoClient.close();
                    mongoClient = null;
                    return true;
                } else {
                    uri = null;
                    mongoClient.close();
                    mongoClient = null;
                    return false;
                }
            } else {
                Connection uri = DriverManager.getConnection(url2, user2, pass2);
                return uri != null;
            }
        } catch (Exception var11) {
            System.out.println(var11.getMessage());
            return false;
        }
    }

    public static int setupdateData(String sql) throws Exception {
        Connection conn = getConnection();
        Statement stmt = null;

        int var5;
        try {
            stmt = conn.createStatement();
            var5 = stmt.executeUpdate(sql);
        } catch (Exception var12) {
            System.out.println(var12.getMessage());
            throw new Exception(var12.getMessage());
        } finally {
            try {
                stmt.close();
                conn.close();
            } catch (SQLException var11) {
                System.out.println(var11.getMessage());
                throw new Exception(var11.getMessage());
            }
        }

        return var5;
    }

    public int updateExecuteBatch(List<String> sqlList) throws Exception {
        Connection conn = getConnection();
        conn.setAutoCommit(false);
        Statement stmt = null;

        try {
            stmt = conn.createStatement();
            Iterator var5 = sqlList.iterator();

            while(var5.hasNext()) {
                String sql = (String)var5.next();
                stmt.addBatch(sql);
            }

            int[] updateCounts = stmt.executeBatch();
            conn.commit();
            int var7 = updateCounts.length;
            return var7;
        } catch (Exception var14) {
            conn.rollback();
            System.out.println(var14.getMessage());
            throw new Exception(var14.getMessage());
        } finally {
            try {
                stmt.close();
                conn.close();
            } catch (SQLException var13) {
                System.out.println(var13.getMessage());
                throw new Exception(var13.getMessage());
            }
        }
    }

    public List<Map<String, Object>> queryForList(String sql) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        int maxSize = 1;
        String[] fields = (String[])null;
        List<String> times = new ArrayList();
        List<String> clob = new ArrayList();
        List<String> binary = new ArrayList();
        List<Map<String, Object>> rows = new ArrayList();
        Map row = null;
        conn = getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        rsmd = rs.getMetaData();
        maxSize = rsmd.getColumnCount();
        fields = new String[maxSize];

        for(int i = 0; i < maxSize; ++i) {
            fields[i] = rsmd.getColumnLabel(i + 1);
            if ("java.sql.Timestamp".equals(rsmd.getColumnClassName(i + 1)) || "oracle.sql.TIMESTAMP".equals(rsmd.getColumnClassName(i + 1))) {
                times.add(fields[i]);
            }

            if ("oracle.jdbc.OracleClob".equals(rsmd.getColumnClassName(i + 1)) || "oracle.jdbc.OracleBlob".equals(rsmd.getColumnClassName(i + 1))) {
                clob.add(fields[i]);
            }

            if ("[B".equals(rsmd.getColumnClassName(i + 1))) {
                binary.add(fields[i]);
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        while(rs.next()) {
            row = new LinkedHashMap();

            for(int i = 0; i < maxSize; ++i) {
                Object value = times.contains(fields[i]) ? rs.getTimestamp(fields[i]) : rs.getObject(fields[i]);
                if (times.contains(fields[i]) && value != null) {
                    value = sdf.format(value);
                }

                if (clob.contains(fields[i]) && value != null) {
                    value = "(Blob)";
                }

                if (binary.contains(fields[i]) && value != null) {
                    value = new String((byte[])value);
                }

                row.put(fields[i], value);
            }

            rows.add(row);
        }

        try {
            rs.close();
            pstmt.close();
            conn.close();
            return rows;
        } catch (SQLException var16) {
            throw new Exception(var16.getMessage());
        }
    }

    public static List<Map<String, Object>> queryForList2(String sql) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        int maxSize = 1;
        String[] fields = (String[])null;
        List<Map<String, Object>> rows = new ArrayList();
        Map row = null;
        conn = getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        rsmd = rs.getMetaData();
        maxSize = rsmd.getColumnCount();
        fields = new String[maxSize];

        while(rs.next()) {
            row = new HashMap();

            for(int i = 0; i < maxSize; ++i) {
                row.put(rsmd.getColumnLabel(i + 1), rs.getObject(rsmd.getColumnLabel(i + 1)));
            }

            rows.add(row);
        }

        return rows;
    }

    public static List<Map<String, Object>> queryForListPageForMSSQL(String sql, int maxRow, int beginIndex) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        int maxSize = 1;
        String[] fields = (String[])null;
        List<String> times = new ArrayList();
        List<Map<String, Object>> rows = new ArrayList();
        Map row = null;
        conn = getConnection();
        pstmt = conn.prepareStatement(sql, 1005, 1008);
        pstmt.setMaxRows(maxRow);
        rs = pstmt.executeQuery();
        rsmd = rs.getMetaData();
        maxSize = rsmd.getColumnCount();
        fields = new String[maxSize];

        for(int i = 0; i < maxSize; ++i) {
            fields[i] = rsmd.getColumnLabel(i + 1);
            if ("java.sql.Timestamp".equals(rsmd.getColumnClassName(i + 1))) {
                times.add(fields[i]);
            }
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        rs.absolute(beginIndex);

        while(rs.next()) {
            row = new HashMap();

            for(int i = 0; i < maxSize; ++i) {
                Object value = times.contains(fields[i]) ? rs.getTimestamp(fields[i]) : rs.getObject(fields[i]);
                if (times.contains(fields[i]) && value != null) {
                    value = sdf.format(value);
                }

                row.put(fields[i], value);
            }

            rows.add(row);
        }

        try {
            rs.close();
            pstmt.close();
            conn.close();
            return rows;
        } catch (SQLException var15) {
            throw new Exception(var15.getMessage());
        }
    }

    public static List<Map<String, Object>> queryForListWithType(String sql) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList rows2 = new ArrayList();

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsme = rs.getMetaData();
            int columnCount = rsme.getColumnCount();
            rs.next();

            for(int i = 1; i < columnCount + 1; ++i) {
                Map<String, Object> map = new HashMap();
                map.put("column_name", rsme.getColumnName(i));
                map.put("column_value", rs.getObject(rsme.getColumnName(i)));
                map.put("data_type", rsme.getColumnTypeName(i));
                map.put("precision", rsme.getPrecision(i));
                map.put("isAutoIncrement", rsme.isAutoIncrement(i));
                map.put("is_nullable", rsme.isNullable(i));
                map.put("isReadOnly", rsme.isReadOnly(i));
                rows2.add(map);
            }
        } catch (Exception var17) {
            System.out.println("queryForListWithType  " + var17.getMessage());
        } finally {
            try {
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException var16) {
                ;
            }

        }

        return rows2;
    }

    public static List<Map<String, Object>> queryForColumnOnly(String sql) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList rows2 = new ArrayList();

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            ResultSetMetaData rsme = rs.getMetaData();
            int columnCount = rsme.getColumnCount();

            for(int i = 1; i < columnCount + 1; ++i) {
                Map<String, Object> map = new HashMap();
                map.put("column_name", rsme.getColumnName(i));
                map.put("data_type", rsme.getColumnTypeName(i));
                map.put("precision", rsme.getPrecision(i));
                map.put("isAutoIncrement", rsme.isAutoIncrement(i));
                map.put("is_nullable", rsme.isNullable(i));
                map.put("isReadOnly", rsme.isReadOnly(i));
                rows2.add(map);
            }
        } catch (Exception var17) {
            System.out.println("queryForColumnOnly  " + var17.getMessage());
        } finally {
            try {
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException var16) {
                ;
            }

        }

        return rows2;
    }

    public static List<Map<String, Object>> executeSqlForColumns(String sql) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSetMetaData rsmd = null;
        int maxSize = 1;
        List<Map<String, Object>> rows = new ArrayList();
        conn = getConnection();
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
        rsmd = rs.getMetaData();
        maxSize = rsmd.getColumnCount();

        for(int i = 0; i < maxSize; ++i) {
            Map<String, Object> map = new HashMap();
            map.put("column_name", rsmd.getColumnLabel(i + 1));
            map.put("data_type", rsmd.getColumnTypeName(i + 1));
            rows.add(map);
        }

        rs.close();
        pstmt.close();
        conn.close();
        return rows;
    }

    public static int executeQueryForCount(String sql) {
        int rowCount = 0;
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.createStatement();

            Object count;
            for(rs = stmt.executeQuery(sql); rs.next(); rowCount = Integer.parseInt(count.toString())) {
                count = rs.getObject("count(*)");
            }
        } catch (Exception var14) {
            System.out.println(var14.getMessage());
        } finally {
            try {
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException var13) {
                ;
            }

        }

        return rowCount;
    }

    public static int executeQueryForCountForPostgesSQL(String sql) {
        int rowCount = 0;
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.createStatement();

            Object count;
            for(rs = stmt.executeQuery(sql); rs.next(); rowCount = Integer.parseInt(count.toString())) {
                count = rs.getObject("count");
            }
        } catch (Exception var14) {
            System.out.println(var14.getMessage());
        } finally {
            try {
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException var13) {
                ;
            }

        }

        return rowCount;
    }

    public static int executeQueryForCount2(String sql) {
        int rowCount = 0;
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            rs.last();
            rowCount = rs.getRow();
        } catch (Exception var14) {
            System.out.println(var14.getMessage());
        } finally {
            try {
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException var13) {
                ;
            }

        }

        return rowCount;
    }

    public static boolean executeQuery(String sql) {
        boolean bl = false;
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;

        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                bl = true;
            }
        } catch (Exception var14) {
            ;
        } finally {
            try {
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException var13) {
                ;
            }

        }

        return bl;
    }

    public static boolean testConn() {
        boolean bl = false;
        Connection conn = getConnection();
        if (conn != null) {
            bl = true;
        }

        try {
            conn.close();
        } catch (Exception var3) {
            ;
        }

        return bl;
    }

    public String getPrimaryKeys(String databaseName, String tableName) {
        Connection conn = null;
        new ArrayList();

        try {
            conn = getConnection();
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs2 = metadata.getPrimaryKeys(databaseName, (String)null, tableName);
            if (rs2.next()) {
                System.out.println("主键名称: " + rs2.getString(4));
                String var8 = rs2.getString(4);
                return var8;
            }
        } catch (Exception var17) {
            System.out.println("queryForColumnOnly  " + var17.getMessage());
        } finally {
            try {
                conn.close();
            } catch (SQLException var16) {
                ;
            }

        }

        return "";
    }

    public List<String> getPrimaryKeyss(String databaseName, String tableName) {
        Connection conn = null;
        ArrayList rows2 = new ArrayList();

        try {
            conn = getConnection();
            DatabaseMetaData metadata = conn.getMetaData();
            ResultSet rs2 = metadata.getPrimaryKeys(databaseName, (String)null, tableName);

            while(rs2.next()) {
                System.out.println("主键名称2: " + rs2.getString(4));
                rows2.add(rs2.getString(4));
            }
        } catch (Exception var15) {
            System.out.println("queryForColumnOnly  " + var15.getMessage());
        } finally {
            try {
                conn.close();
            } catch (SQLException var14) {
                ;
            }

        }

        return rows2;
    }

    public static int executeQueryForCountForOracle(String sql) {
        int rowCount = 0;
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        String sql3 = " select count(*) as count from  (" + sql + ")";

        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql3);
            rs.next();
            rowCount = rs.getInt("count");
        } catch (Exception var15) {
            System.out.println(var15.getMessage());
        } finally {
            try {
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException var14) {
                ;
            }

        }

        return rowCount;
    }

    public static int executeQueryForCountForPostgreSQL(String sql) {
        int rowCount = 0;
        Connection conn = getConnection();
        Statement stmt = null;
        ResultSet rs = null;
        String sql3 = " select count(*) as count from  (" + sql + ") t ";

        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql3);
            rs.next();
            rowCount = rs.getInt("count");
        } catch (Exception var15) {
            System.out.println(var15.getMessage());
        } finally {
            try {
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException var14) {
                ;
            }

        }

        return rowCount;
    }
}
