merging = function(folder)
{
	adresses = read.table(paste(folder,"/Extraction/adresses.txt",sep=""), sep="\t", header = FALSE)
	dates = read.table(paste(folder,"/Extraction/dates.txt",sep=""), sep="\t", header = FALSE)
	subject = read.table(paste(folder,"/Extraction/sub.txt",sep=""), sep="\t", header = FALSE)

	# Create a single dataset containing all data

	data = cbind(as.data.frame(adresses[,1:2]),as.data.frame(adresses[,3]),as.data.frame(dates[,3]),as.data.frame(subject[,3]))

	# Suppress empty data or wrong format

	data = data[data[,4]!="",]	
	data = data[which(substr(data[,4],1,1)!="D"),]	

	# Transformation des dates au format JJ/MM/AAAA HH:MM:SS en 6 colonnes

	col <- data.frame(t(matrix(
			unlist(strsplit(as.vector(data[,4]), split = " ")), 
			ncol = length(data[,4]), nrow = 2)))

	date1 <- data.frame(t(matrix(
			unlist(strsplit(as.vector(col[,1]), split = "/")), 
			ncol = length(col[,1]), nrow = 3)))
	date2 <- data.frame(t(matrix(
			unlist(strsplit(as.vector(col[,2]), split = ":")), 
			ncol = length(col[,2]), nrow = 3)))
	
	# Reconstruction of the dataset

	data = cbind(as.data.frame(data[,1:3]), as.data.frame(date1),as.data.frame(date2), as.data.frame(data[,5]))
	colnames(data) = c("Folder", "File", "Sender", "Day", "Month", "Year", "Hour", "Minute", "Second", "Subject")

	# Order datas by date of emission

	s = sort.int(as.integer(data$Second) 
			+ as.integer(data$Minute) * 60
			+ as.integer(data$Hour) * 60 * 60
			+ as.integer(data$Day) * 60 *60 * 24
			+ as.integer(data$Month) * 60 *60 * 24 * 31
			+ as.integer(data$Year) * 60 * 60 * 24 * 31 * 366, index.return = TRUE)[2]$ix
	data = data[s,]

	# Write the data in a file

	write.table(data,paste(folder,"/Extraction/DataAll.txt",sep = ""),sep="\t",col.names=TRUE,row.names=FALSE)
}