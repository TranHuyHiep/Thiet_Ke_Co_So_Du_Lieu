#include<bits/stdc++.h>
using namespace std;
class Grade{
	
	int sbd,nam,toan,ly,hoa;
	string ten,sex;
	
	public:
		
		Grade(){
		}
		
		Grade(string ten,int sbd,int nam,int toan,int ly,int hoa,string sex ){
			this->sbd = sbd;
			this->nam = nam;
			this->toan = toan;
			this->ly = ly;
			this->hoa = hoa;
			this->ten = ten;
			this->sex = sex;
		}
		
		void In(){
			cout<<"\n-----NHAP CON ME M DI THANG NGU TIEN!!!!!!-----/n";
			cout<<"\nNAME: "; fflush(stdin);
			getline(cin,ten);
			cout<<"\nDATE of BIRTH: "; cin>>nam;
			cout<<"\nSEX: "; fflush(stdin);
			getline(cin,sex);
			cout<<"\nIDENTIFICATION NUMBER: "; cin>>sbd;
			cout<<"\nMATH: "; cin>>toan;
			cout<<"\nPHYSICS: "; cin>>ly;
			cout<<"\nCHEMISTRY: "; cin>>hoa;	
		}
		void Display(){
			cout<<"\n----- "<<ten<<" <"<<nam<<","<<sex<<","<<sbd<<","<<toan<<","<<ly<<","<<hoa<<">-----";
		}
		
		////// get set
		string getTen(){
			return ten;
		}
		void setTen(){
			this->ten = ten;
		}
		//
		int getNam(){
			return nam;
		}
		void setNam(){
			this->nam = nam;
		}
		//
		string getSex(){
			return sex;
		}
		void setSex(){
			this->sex = sex;
		}
		//
		int getSbd(){
			return sbd;
		}
		void setSbd(){
			this->sbd = sbd;
		}
		//
		int getToan(){
			return toan;
		}
		void setToan(){
			this->toan = toan;
		}
		//
		int getLy(){
			return ly;
		}
		void setLy(){
			this->ly = ly;
		}
		//
		int getHoa(){
			return hoa;
		}
		void setHoa(){
			this->hoa = hoa;
		}
		
}; 
int main(){
	Grade a;
	a.In();
	a.Display();
}

