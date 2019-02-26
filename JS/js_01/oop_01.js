class Point{
  constructor(x, y){
    this.x = x;
    this.y = y;
    console.log("Point~~~~~");
  }

  // show(){
  //   console.log(this, this.x, this.y);
  // }
}
    this.z = z;

class Point3D extends Point{
  constructor(x, y, z){
    super(x,y);
  }

  show(){
    console.log(this, this.x, this.y, this.z);
  }
}

console.log(Point3D);
p2 = new Point3D(10, 20, 30);
console.log(p2);
p2.show();