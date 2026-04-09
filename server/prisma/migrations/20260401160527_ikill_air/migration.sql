-- CreateTable
CREATE TABLE "Product" (
    "Pro_ID" SERIAL NOT NULL,
    "Pro_Name" TEXT NOT NULL,
    "Pro_Price" DOUBLE PRECISION NOT NULL,
    "Pro_Cat" TEXT NOT NULL,
    "Pro_Quantity" INTEGER NOT NULL,
    "Pro_Status" BOOLEAN NOT NULL,
    "Pro_Img" TEXT NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("Pro_ID")
);

-- CreateTable
CREATE TABLE "Useradmin" (
    "UA_ID" SERIAL NOT NULL,
    "UA_Username" TEXT NOT NULL,
    "UA_Passwd" TEXT NOT NULL,
    "UA_Role" BOOLEAN NOT NULL,
    "UA_Status" BOOLEAN NOT NULL,
    "UA_isNoti" BOOLEAN NOT NULL,
    "UA_CreDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UA_Email" TEXT NOT NULL,

    CONSTRAINT "Useradmin_pkey" PRIMARY KEY ("UA_ID")
);

-- CreateTable
CREATE TABLE "Notification" (
    "Noti_ID" SERIAL NOT NULL,
    "Noti_Name" TEXT NOT NULL,
    "Noti_Message" TEXT NOT NULL,
    "Noti_Date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UA_ID" INTEGER NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("Noti_ID")
);

-- CreateTable
CREATE TABLE "Order" (
    "Ord_ID" SERIAL NOT NULL,
    "Ord_TotalPrice" DOUBLE PRECISION NOT NULL,
    "Ord_PayMet" BOOLEAN NOT NULL,
    "Ord_status" BOOLEAN NOT NULL,
    "Ord_CreDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UA_ID" INTEGER NOT NULL,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("Ord_ID")
);

-- CreateTable
CREATE TABLE "News" (
    "News_ID" SERIAL NOT NULL,
    "News_Name" TEXT NOT NULL,
    "News_Source" TEXT NOT NULL,
    "News_Img" TEXT NOT NULL,
    "News_Date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UA_ID" INTEGER NOT NULL,

    CONSTRAINT "News_pkey" PRIMARY KEY ("News_ID")
);

-- CreateTable
CREATE TABLE "Orditem" (
    "Orditems_ID" SERIAL NOT NULL,
    "Orditems_Quant" INTEGER NOT NULL,
    "Orditems_Price" DOUBLE PRECISION NOT NULL,
    "Ord_ID" INTEGER NOT NULL,
    "Pro_ID" INTEGER NOT NULL,

    CONSTRAINT "Orditem_pkey" PRIMARY KEY ("Orditems_ID")
);

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_UA_ID_fkey" FOREIGN KEY ("UA_ID") REFERENCES "Useradmin"("UA_ID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_UA_ID_fkey" FOREIGN KEY ("UA_ID") REFERENCES "Useradmin"("UA_ID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "News" ADD CONSTRAINT "News_UA_ID_fkey" FOREIGN KEY ("UA_ID") REFERENCES "Useradmin"("UA_ID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Orditem" ADD CONSTRAINT "Orditem_Ord_ID_fkey" FOREIGN KEY ("Ord_ID") REFERENCES "Order"("Ord_ID") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Orditem" ADD CONSTRAINT "Orditem_Pro_ID_fkey" FOREIGN KEY ("Pro_ID") REFERENCES "Product"("Pro_ID") ON DELETE RESTRICT ON UPDATE CASCADE;
