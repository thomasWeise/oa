# 序言 {-}

很久以前我在攻读博士期间写过*Global Optimization Algorithms &ndash; Theory and Applications*&nbsp;[@WGOEB]，现在我想写一个更直接的优化和元启发式指南。
目前，[这本书](http://thomasweise.github.io/oa/index.html)处于开发和工作的早期阶段，所以可以期待很多变化。
另外，我主要使用在线工具来翻译这本书，所以会有很多错误。

这本书试图以一种容易理解的方式为没有该领域背景的本科生和研究生介绍优化算法。
我们提供了优化算法在实践中如何工作的直觉。
我们学习在解决优化问题时要寻找什么。
本书还讨论了如何从简单、有效的“概念证明”方法开始，并将其改进为给定问题的有效解决方案。
我们遵循“边做边学”的方法，试图解决一个实际的优化问题，作为整个书的主题。
在介绍了这些算法之后，我们对它们进行了实现和应用。
这种方法允许我们根据实际结果讨论算法的优缺点。
我们学习了如何比较不同优化算法的性能。
我们试图逐步改进优化算法。
我们从非常简单的方法开始，这些方法不能很好地工作，最后转移到有效的元启发式。

我们使用Python编程语言编写的具体示例和优化算法实现。
这些可以在存储库*[thomasWeise/mopitpy](https://github.com/thomasWeise/moptipy)*中以GNU通用公共许可证版本3,2007年6月29日语言免费获得。
每个源代码清单的标题中都有一个*(src)*超链接，链接到存储库中该文件的完整版本。
书中的源代码清单通常是实际源代码的删节摘要。
这意味着我们将省略源代码清单中许多对理解算法没有必要的细节。
例如，我们将省略Python类型提示、参数值的完整性检查，甚至完整的方法。
这些详细信息将出现在[GitHub存储库](\repo{mp}{repo.url})中可用的完整代码版本中。
因此，GitHub存储库中的完整代码版本看起来可能与书中插图的删节代码不同。
为了完全理解代码示例，我们建议读者熟悉Python、[numpy](https://numpy.org/)和[matplotlib](https://matplotlib.org/)。
当然，如果你只是为了学习算法而阅读这本书，你可以忽略程序源代码示例。

本书以“署名-非商业性使用-相同方式共享4.0国际” (CC&nbsp;BY-NC-SA&nbsp;4.0) 许可证发布，请参阅<https://creativecommons.org/licenses/by-nc-sa/4.0/deed.zh>以获取摘要。
我试图用多种语言并行编写这本书，但我可能无法使它们保持同步。
英文版将始终是最新版本。


| &nbsp;
| Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/5) (汤卫思教授)
| Institute of Applied Optimization (应用优化研究所, [IAO](http://iao.hfuu.edu.cn)),
| School of Artificial Intelligence and Big Data ([人工智能与大数据学院](http://www.hfuu.edu.cn/jsjx/)),
| [Hefei University](http://www.hfuu.edu.cn/english/) ([合肥学院](http://www.hfuu.edu.cn/)),
| Hefei, Anhui, China (中国安徽省合肥市).
| 网站: <http://iao.hfuu.edu.cn/5>
| 电子邮件地址: <tweise@hfuu.edu.cn>, <tweise@ustc.edu.cn>
| &nbsp;


如果你想引用这本书，你可以使用以下[BibTeX](http://www.bibtex.org/)信息:


```
@book{oa,
  author    = {Thomas Weise},
  title     = {\meta{title}},
  year      = {\meta{year}},
  publisher = {Institute of Applied Optimization ({IAO}),
               School of Artificial Intelligence and Big Data,
               Hefei University},
  address   = {Hefei, Anhui, China},
  url       = {http://thomasweise.github.io/oa/},
}
```


这本书的版本信息如下：


| &nbsp;
| 书库：[\meta{repo.name}](\meta{repo.url})
| 书库提交：\meta{repo.commit}
| 书库日期：\meta{repo.date}
| 源代码库：[\repo{mp}{repo.name}](\repo{mp}{repo.url})
| 源代码库提交：\repo{mp}{repo.commit}
| 源代码库日期：\repo{mp}{repo.date}
| &nbsp;

