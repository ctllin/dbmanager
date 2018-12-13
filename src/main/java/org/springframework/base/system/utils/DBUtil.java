package org.springframework.base.system.utils;

/**
 * <p>Title: DBUtil</p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2018</p>
 * <p>Company: www.hanshow.com</p>
 *
 * @author guolin
 * @version 1.0
 * @date 2018-07-21 16:15
 */
//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

import com.ctl.utils.ConfigUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DBUtil {
    static Logger logger = LoggerFactory.getLogger(DBUtil.class);
    private final String databaseName= ConfigUtils.getType("sqlite.db.path");
    public DBUtil() {
    }

    public boolean do_update(String sql) throws Exception {
        String dbPath = Constants.DATABASEPATH + databaseName;
        Class.forName("org.sqlite.JDBC");
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        Statement stat = conn.createStatement();
        stat.executeUpdate(sql);
        conn.close();
        return true;
    }

    public boolean do_update2(String sql) throws Exception {
        String dbPath = this.getClass().getResource("/").getPath();
        String os = System.getProperty("os.name");
        if (os.toLowerCase().startsWith("win") && dbPath.startsWith("/")) {
            dbPath = dbPath.substring(1);
            dbPath = dbPath.replace("/", "\\");
        }

        dbPath = dbPath + databaseName;
        Class.forName("org.sqlite.JDBC");
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        Statement stat = conn.createStatement();
        stat.executeUpdate(sql);
        conn.close();
        return true;
    }

    public List executeQuery(String sql) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        List rslist = new ArrayList();
        StringBuffer sqlPage = new StringBuffer(sql + " ");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String dbPath = Constants.DATABASEPATH + databaseName;
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            pstmt = conn.prepareStatement(sqlPage.toString());
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();

            while(rs.next()) {
                Map row = new HashMap(numberOfColumns);

                for(int i = 1; i <= numberOfColumns; ++i) {
                    Object o = rs.getObject(i);
                    if ("Date".equalsIgnoreCase(rsmd.getColumnTypeName(i)) && o != null) {
                        row.put(rsmd.getColumnName(i), formatter.format(o));
                    } else {
                        row.put(rsmd.getColumnName(i), o == null ? "" : o);
                    }
                }

                rslist.add(row);
            }
        } catch (Exception var24) {
            try {
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException e) {
                logger.error("executeQuery",e);
            }
        } finally {
            try {
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException e) {
                logger.error("executeQuery",e);
            }

        }

        return rslist;
    }

    public List executeQuery2(String sql) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
        List rslist = new ArrayList();
        StringBuffer sqlPage = new StringBuffer(sql + " ");
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String dbPath = this.getClass().getResource("/").getPath();
            String os = System.getProperty("os.name");
            if (os.toLowerCase().startsWith("win") && dbPath.startsWith("/")) {
                dbPath = dbPath.substring(1);
                dbPath = dbPath.replace("/", "\\");
            }

            dbPath = dbPath.replace("%20", " ");
            dbPath = dbPath + databaseName;
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            pstmt = conn.prepareStatement(sqlPage.toString());
            rs = pstmt.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int numberOfColumns = rsmd.getColumnCount();

            while(rs.next()) {
                Map row = new HashMap(numberOfColumns);

                for(int i = 1; i <= numberOfColumns; ++i) {
                    Object o = rs.getObject(i);
                    if ("Date".equalsIgnoreCase(rsmd.getColumnTypeName(i)) && o != null) {
                        row.put(rsmd.getColumnName(i), formatter.format(o));
                    } else {
                        row.put(rsmd.getColumnName(i), o == null ? "" : o);
                    }
                }

                rslist.add(row);
            }
        } catch (Exception var25) {
            logger.error("executeQuery2系统启动时，取路径出错，程序布署路径不能有空隔！",var25);
            try {
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException var24) {
                logger.error("executeQuery2",var24);
            }
        } finally {
            try {
                rs.close();
                pstmt.close();
                conn.close();
            } catch (SQLException var23) {
                logger.error("executeQuery2",var23);
            }

        }

        return rslist;
    }

    public int executeQueryForCount(String sql) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        int rowCount = 0;

        try {
            String dbPath = Constants.DATABASEPATH + databaseName;
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            PreparedStatement pstmt = conn.prepareStatement(sql);

            for(rs = pstmt.executeQuery(); rs.next(); ++rowCount) {
            }
        } catch (Exception var18) {
            logger.error("executeQueryForCount",var18);

            try {
                rs.close();
                conn.close();
            } catch (SQLException var17) {
                logger.error("executeQueryForCount",var17);

            }
        } finally {
            try {
                rs.close();
                conn.close();
            } catch (SQLException var16) {
                logger.error("executeQueryForCount",var16);
            }

        }

        return rowCount;
    }

    public Object setinsertData(String sql) throws Exception {
        String dbPath = Constants.DATABASEPATH + databaseName;
        Class.forName("org.sqlite.JDBC");
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        Statement stmt = null;
        String flagOper = "0";

        Integer var8;
        try {
            stmt = conn.createStatement();
            var8 = stmt.executeUpdate(sql);
        } catch (SQLException var15) {
            flagOper = "1";
            throw new Exception(var15.getMessage());
        } finally {
            try {
                stmt.close();
                conn.close();
            } catch (SQLException var14) {
                throw new Exception(var14.getMessage());
            }
        }

        return var8;
    }

    public List<Map<String, Object>> getConfigList() {
        DBUtil db1 = new DBUtil();
        List<Map<String, Object>> list = db1.executeQuery(" select * from  treesoft_config ");
        return list;
    }

    public List<Map<String, Object>> getDataSynchronizeList2(String state) {
        DBUtil db1 = new DBUtil();
        List<Map<String, Object>> list = new ArrayList();
        String sql = "";

        try {
            if (state.equals("")) {
                sql = " select t1.id, t1.state , t1.name, t1.createDate,t1.updateDate ,t1.souceConfig_id as souceConfigId, t1.souceDataBase, t1.doSql ,t1.targetConfig_id as targetConfigId, t1.targetDataBase,t1.targetTable, t1.cron, t1.operation, t1.comments, t1.status , t2.ip||':'||t2.port as souceConfig , t3.ip||':'||t3.port as targetConfig from  treesoft_data_synchronize t1 left join treesoft_config t2 on t1.souceConfig_id = t2.id LEFT JOIN treesoft_config t3 on t1.targetConfig_id = t3.id  ";
            } else {
                sql = " select t1.id, t1.state , t1.name, t1.createDate,t1.updateDate ,t1.souceConfig_id as souceConfigId, t1.souceDataBase, t1.doSql ,t1.targetConfig_id as targetConfigId, t1.targetDataBase,t1.targetTable, t1.cron, t1.operation, t1.comments, t1.status , t2.ip||':'||t2.port as souceConfig , t3.ip||':'||t3.port as targetConfig from  treesoft_data_synchronize t1 left join treesoft_config t2 on t1.souceConfig_id = t2.id LEFT JOIN treesoft_config t3 on t1.targetConfig_id = t3.id where t1.state='" + state + "'";
            }

            list = db1.executeQuery2(sql);
        } catch (Exception var6) {
            logger.error("getDataSynchronizeList2",var6);
            var6.printStackTrace();
        }

        return (List)list;
    }

    public List<Map<String, Object>> getDataSynchronizeListById(String[] ids) {
        DBUtil db1 = new DBUtil();
        StringBuffer sb = new StringBuffer();

        for(int i = 0; i < ids.length; ++i) {
            sb = sb.append("'" + ids[i] + "',");
        }

        String newStr = sb.toString();
        String str3 = newStr.substring(0, newStr.length() - 1);
        List<Map<String, Object>> list = db1.executeQuery(" select id, name, souceConfig_id as souceConfigId,souceDataBase, doSql ,targetConfig_id as targetConfigId, targetDataBase,targetTable, cron,operation,comments,status,state,qualification from  treesoft_data_synchronize where id in (" + str3 + ") ");
        return list;
    }

    public List<Map<String, Object>> getPersonList() {
        DBUtil db1 = new DBUtil();
        List<Map<String, Object>> list = db1.executeQuery(" select * from  treesoft_users ");
        return list;
    }
}
