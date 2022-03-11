StartEndView是一个方便布局的组件。

![image-20220311134055912](https://gitee.com/joser_zhang/upic/raw/master/uPic/202203111340003.png)

![image-20220311134245088](https://gitee.com/joser_zhang/upic/raw/master/uPic/202203111342107.png)

## 属性

| 属性               | 类型               | 含义                                       |
| ------------------ | ------------------ | ------------------------------------------ |
| start              | Widget             | 开始布局视图                               |
| end                | Widget             | 结束布局视图                               |
| space              | double             | 中间间隙 默认为10                          |
| direction          | MainDirection      | 布局方向 horizontal(横向) vertical（纵向） |
| crossAxisAlignment | CrossAxisAlignment | 垂直方向的对其方式                         |

## StartEndBuilderView

通过 Builder 方式进行布局

### StartEndBuilderView.start

Start 可以通过 Builder 进行布局

### StartEndBuilderView.end

End 可以通过 Builder 进行布局