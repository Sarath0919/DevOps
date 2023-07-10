ls -a
pwd

#this is comment
echo "hello world"

#to print something in color as follows
# echo -e "\e[COLmMesssage\e[0m"
# -e : to enable colors
# \e[COLm - to enable certain color ; COL - is number to presents some color
#\e[0m  -to disable the colors which we enabled
# color codes as RED(31),Green(32),Yellow(33),Blue(34),Magneta(35),Cyan(36)

echo -e "\e[31mHello i am Red\e[0m"
echo -e "\e[32mHello i am Green\e[0m"
echo -e "\e[33mHello i am Yellow\e[0m"
echo -e "\e[34mHello i am Blue\e[0m"
echo -e "\e[35mHello i am Magneta\e[0m"
echo -e "\e[36mHello i am Cyan\e[0m"