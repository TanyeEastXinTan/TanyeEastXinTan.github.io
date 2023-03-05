CREATE DATABASE IF NOT EXISTS db_Marketplace;

USE db_Marketplace;

DROP TABLE IF EXISTS tb_vendor;
CREATE TABLE IF NOT EXISTS tb_vendor(
	vid VARCHAR(50) PRIMARY KEY COMMENT '供应商编号',
    vname VARCHAR(20) NOT NULL COMMENT '供应商名称',
    vaddress VARCHAR(50) NOT NULL COMMENT '供应商地址',
    vphone VARCHAR(15) NOT NULL COMMENT '联系电话'
) ENGINE=INNODB COMMENT '供应商表';

DROP TABLE IF EXISTS tb_goods_type;
CREATE TABLE IF NOT EXISTS tb_goods_type(
	gt_id VARCHAR(50) PRIMARY KEY COMMENT '商品分类编号',
    gt_name VARCHAR(20) NOT NULL COMMENT '商品分类名称',
    vid VARCHAR(50) NOT NULL COMMENT '供应商编号',
    inventory INT NOT NULL COMMENT '库存'
) ENGINE=INNODB COMMENT '商品分类表';


DROP TABLE IF EXISTS tb_good;
CREATE TABLE IF NOT EXISTS tb_good(
	gid VARCHAR(50) PRIMARY KEY COMMENT '商品编号',
    gt_id VARCHAR(50) NOT NULL COMMENT '商品分类编号',
    gname VARCHAR(50) NOT NULL COMMENT '商品名称',
    gprice float4 NOT NULL COMMENT '商品价格',
    gsize VARCHAR(6) NOT NULL COMMENT '商品型号',
    gcontent TEXT NULL COMMENT '商品介绍'
) ENGINE=INNODB COMMENT '商品表';


DROP TABLE IF EXISTS tb_member;
CREATE TABLE IF NOT EXISTS tb_member(
	mid INT AUTO_INCREMENT PRIMARY KEY COMMENT '会员等级编号',
    mtype VARCHAR(6) NOT NULL COMMENT '会员类型',
    discount double NOT NULL COMMENT '折扣'
) ENGINE=INNODB COMMENT '会员等级表';

DROP TABLE IF EXISTS tb_customer;
CREATE TABLE IF NOT EXISTS tb_customer(
	cid INT AUTO_INCREMENT PRIMARY KEY COMMENT '顾客编号',
    cname VARCHAR(20) NOT NULL COMMENT '用户名',
    mid INT NOT NULL COMMENT '会员等级编号',
    mpnone VARCHAR(11) NOT NULL COMMENT '联系电话',
    maddress VARCHAR(100) NOT NULL COMMENT '收货地址',
    Registration_time DATE NOT NULL COMMENT '注册时间',
    mpassword VARCHAR(32) NOT NULL COMMENT '用户密码'
) ENGINE=INNODB COMMENT '顾客表';


DROP TABLE IF EXISTS tb_orders;
CREATE TABLE IF NOT EXISTS tb_orders(
	oid BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单编号',
    gid VARCHAR(50) NOT NULL COMMENT '商品编号',
    cid INT NOT NULL COMMENT '顾客编号',
    gnumber INT NOT NULL COMMENT '商品数量',
    create_time DATE NOT NULL COMMENT '创建时间'
) ENGINE=INNODB COMMENT '订单表';


DROP TABLE IF EXISTS tb_payment;
CREATE TABLE IF NOT EXISTS tb_payment(
	pid BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '流水号',
	cid INT NOT NULL COMMENT '顾客编号',
	gid VARCHAR(50) NOT NULL COMMENT '商品编号',
    ptype ENUM('微信','支付宝','云闪付') DEFAULT '支付宝' NOT NULL COMMENT '付款方式',
    pmoney DECIMAL(8, 2) NOT NULL COMMENT '付款金额'
) ENGINE=INNODB COMMENT '付款表';


DROP TABLE IF EXISTS tb_goods_out;
CREATE TABLE IF NOT EXISTS tb_goods_out(
	pid BIGINT NOT NULL COMMENT '流水号',
    gstatus VARCHAR(10) NOT NULL COMMENT '商品状态',
    courier VARCHAR(10) NOT NULL COMMENT '快递名称',
    intime DATE NOT NULL COMMENT '预计送达时间'
) ENGINE=INNODB COMMENT '商品出库表';



DROP TABLE IF EXISTS tb_detail;
CREATE TABLE IF NOT EXISTS tb_detail(
	did BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL COMMENT '订单处理编号',
    pid BIGINT NOT NULL COMMENT '流水号',
    return_type ENUM('签收','退货','换货') NOT NULL COMMENT '交易类型',
    reason VARCHAR(300) NULL COMMENT '原因',
    dnumber INT NULL NULL COMMENT '数量',
    dtime DATE NOT NULL COMMENT '时间',
    dmoney DECIMAL(8, 2) NOT NULL COMMENT '退款金额'
)ENGINE=INNODB COMMENT '订单处理表';


-- 完整性约束
ALTER TABLE tb_goods_type ADD CONSTRAINT FK_goods_vid FOREIGN KEY(vid) REFERENCES tb_vendor(vid);
ALTER TABLE tb_good ADD CONSTRAINT FK_good_gtid FOREIGN KEY (gt_id) REFERENCES tb_goods_type(gt_id);
ALTER TABLE tb_customer ADD CONSTRAINT FK_customer_mid FOREIGN KEY (mid) REFERENCES tb_member(mid);
ALTER TABLE tb_orders ADD CONSTRAINT FK_order_gid FOREIGN KEY (gid) REFERENCES tb_good(gid);
ALTER TABLE tb_orders ADD CONSTRAINT FK_order_cid FOREIGN KEY (cid) REFERENCES tb_customer(cid);
ALTER TABLE tb_payment ADD CONSTRAINT FK_payment_gid FOREIGN KEY (gid) REFERENCES tb_orders(gid);
ALTER TABLE tb_payment ADD CONSTRAINT FK_payment_cid FOREIGN KEY (cid) REFERENCES tb_orders(cid);
ALTER TABLE tb_goods_out ADD CONSTRAINT FK_good_out FOREIGN KEY (pid) REFERENCES tb_payment(pid);
ALTER TABLE tb_detail ADD CONSTRAINT FK_detail FOREIGN KEY (pid) REFERENCES tb_goods_out(pid);


-- 索引创建
CREATE INDEX index_goods_id ON tb_good(gid);
CREATE INDEX index_customer_id ON tb_customer(cid);
CREATE INDEX index_orders_id ON tb_orders(oid);

-- 创建视图
create view vw_use_user as 
select t.cname,
	   t.gnumber,
       g.gname
from
(select c.cname,
	   o.gid,
       o.gnumber 
	from tb_customer c join tb_orders o
on c.cid=o.cid) as t 
join tb_good g on
g.gid=t.gid;

