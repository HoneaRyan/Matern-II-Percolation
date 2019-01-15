#ifndef Perc_Point_hpp
#define Perc_Point_hpp

class Point {
private:
	double x_;
	double y_;
	bool isOutside_;




public:
	//Constructors
	Point();
	Point(double, double);

	//Getters
	double getX();
	double getY();
	bool isOutside();

	//Setters
	void setX(double);
	void setY(double);
	void checkOutside();

	bool Outside();
};






#endif