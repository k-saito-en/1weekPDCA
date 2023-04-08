> ⚠️ 現在開発中につき、現時点での実装済み機能のビルドは`develop`ブランチで行ってください

[![1weekPDCA_CI](https://github.com/k-saito-en/1weekPDCA/actions/workflows/1weekPDCA_CI.yml/badge.svg)](https://github.com/k-saito-en/1weekPDCA/actions/workflows/1weekPDCA_CI.yml) 

<img alt="GitHub issues" src="https://img.shields.io/github/issues/k-saito-en/1weekPDCA"> <img alt="GitHub" src="https://img.shields.io/github/license/k-saito-en/1weekPDCA">

![1weekPDCA_README](https://user-images.githubusercontent.com/111550856/221393945-ee5fa6cd-49a5-4266-9a74-5842946ea1d3.png)

# 1weekPDCA

## ▼ 🤔 What? これは何?

このアプリは、**PDCAサイクル** と **目標を大目標・中目標・小目標と階層化することによって達成確率が上がるというアルゴリズム** に基づき、自己実現の手助けをするアプリです。

> 大目標は最終的に達成したいことであり、中目標は大目標を達成するために必要なことであり、小目標は中目標を達成するために具体的に行うことです。このように目標を階層化することで、自分が何をすべきか明確になります。

> PDCAサイクルとは、計画（Plan）、実行（Do）、評価（Check）、改善（Action）の4つのステップを繰り返すことで、業務や目標の達成に向けて効率的に改善していくマネジメント手法です


PDCAサイクルに則って目標を大目標、中目標、小目標と分けると、以下のようなメリットがあります。

- 大目標を中期的・長期的な視点で設定し、中目標や小目標を短期的な視点で設定することで、具体的かつ達成可能な計画を立てることができます[[3]](https://ic.repo.nii.ac.jp/?action=repository_action_common_download&item_id=351&item_no=1&attribute_id=22&file_no=1)。


- 中目標や小目標は大目標に対する進捗度や達成度を測る指標として活用できます[[3]](https://ic.repo.nii.ac.jp/?action=repository_action_common_download&item_id=351&item_no=1&attribute_id=22&file_no=1)。実行した結果を評価し、改善点や課題を明確にすることができます[[1]](https://www.jstage.jst.go.jp/article/naika/105/12/105_2353/_pdf),[[2]](https://www.niziiro.jp/article/260)。


- 小さな成功体験を積み重ねることで、モチベーションや自信を高めることができます[[2]](https://www.niziiro.jp/article/260)。また、失敗や挫折に対しても柔軟に対応し、学びのチャンスと捉えることができます


## ▼ 🤓 Why? どうして作ろうと思ったの?

本アプリの制作を通して自分なりの最適なアーキテクチャを確立し、リファレンスコードにすることを目的にしています。

- `形に残したかったから`

   私は、エンジニアという仕事の魅力の１つは「成果物がわかりやすく形に残ること」だと考えています。 形に残すものは一重に コード のみならず、「つまづいたところ・解決策・参考文献・エビデンスetc...」ありとあらゆる「成果」を issue 等に形として残しています。
   
- `挑戦したかったから`

  このアプリを制作している段階で私はプログラミングに触れ始めて半年もたたない駆け出しです。 エンジニア就活で提出する成果物の一面も備えています。
  そんな中で、「こんな難しそうなのできないよ」と過去に考えていた技術に挑戦し、自分の技術力をどこまで伸ばせるか という私にとっての勝負の場でもあります。
  
  現に、本アプリの開発の中でどんなにつまづいても、最終的には**全て**実現に至っており、一切の妥協は許しません。

# 📱 画面イメージ

## ▼ 全体
|PlanDo 画面|Check 画面(実装中)|Act 画面(実装中)|
|-----|-----|-----|
|![IMG_5178](https://user-images.githubusercontent.com/111550856/221396210-e6834cd6-29ff-4443-b6f1-7ea5f0082872.PNG)|![スクリーンショット 2023-02-26 15 43 20](https://user-images.githubusercontent.com/111550856/221396321-2743f6b1-6a63-40b9-9f08-5fa2dd908d6c.png)|![スクリーンショット 2023-02-26 15 41 22](https://user-images.githubusercontent.com/111550856/221396251-c049554b-eb0b-4702-85b2-a4ad95d23b48.png)|

▼ こだわりポイント
- `UI`
  - [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)を参考にしたUIデザイン[[4]](https://qiita.com/mark_1975M/items/eabdd95ac1de64e4fe1b)
  - 補色性、コントラストを意識し、調和性のあるカラーリング[[5]](https://note.com/mhtcode/n/nf31d73314527),[[6]](https://goworkship.com/magazine/ui-ux-design-colour/)
  - 直感的で楽しい体験をユーザーに提供するアニメーション[[7]](https://qiita.com/hachinobu/items/57d4c305c907805b4a53),[[8]](https://qiita.com/mark_1975M/items/eabdd95ac1de64e4fe1b),[[9]](https://photoshopvip.net/88490)

## ▼ PlanDo 画面

|タスク有り時 画面|タスク無し時 画面|一週間のリザルト 画面(実装中)|
|-----|-----|-----|
|![IMG_5178](https://user-images.githubusercontent.com/111550856/221396210-e6834cd6-29ff-4443-b6f1-7ea5f0082872.PNG)|![IMG_5177](https://user-images.githubusercontent.com/111550856/221396538-efce9047-0221-407e-a89d-9075eb84980b.PNG)|![スクリーンショット 2023-02-26 15 51 36](https://user-images.githubusercontent.com/111550856/221396584-c52446c2-995b-46be-ba0e-7aa82ca7f293.png)|

▼ こだわりポイント
- `表示`
  - プログレスバー・サークル により、全体・タスクごと の進捗が把握できる
  - タスクタイトル・Todoラベル の　TextField は文字数制限がなく、入力量に応じてカード自体が伸縮する。
  - タスク無し時専用の画面を実装し、ユーザーに次にするべき動作を教える
  - 結果画面で「最もつぶやいていたタグ・いないタグ」を表示し、PDCAの中で改善できている箇所、改善が必要な箇所をユーザーに教える(実装中)
  - 「ランダムで名言を返す」という面白いAPIを使い、表示することでユーザーを奮起する(実装中)

- `操作性`
  - タスクカード・Todoラベル は左右のスワイプで削除することができる。
  - 長押しからのドラッグで要素の入れ替えができる(実装中)

## ▼ Check 画面
  - ComingSoon...

## ▼ Act 画面
  - ComingSoon...

# 📚 参考文献リスト
- [[1] 医療の質改善の概念と手法 ―PDCA，six sigmaなど](https://www.jstage.jst.go.jp/article/naika/105/12/105_2353/_pdf)
- [[2] PDCAサイクルが目標達成へのカギ？導入例と社員教育方法について](https://www.niziiro.jp/article/260)
- [[3] PDCAサイクルにより得た学生の教育効果](https://ic.repo.nii.ac.jp/?action=repository_action_common_download&item_id=351&item_no=1&attribute_id=22&file_no=1)
- [[4] モバイルアプリにおけるUIデザイン - Qiita](https://qiita.com/mark_1975M/items/eabdd95ac1de64e4fe1b)
- [[5] アプリUIのデザインにおける配色の基本についてまとめてみた …](https://note.com/mhtcode/n/nf31d73314527)
- [[6] UI/UXデザイナーのための「色」活用ガイド。色選び基礎から …](https://goworkship.com/magazine/ui-ux-design-colour/)
- [[7] iOSアプリ開発でアニメーションするなら押さえておきたい基礎 …](https://qiita.com/hachinobu/items/57d4c305c907805b4a53)
- [[8] モバイルアプリにおけるUIデザイン - Qiita](https://qiita.com/mark_1975M/items/eabdd95ac1de64e4fe1b)
- [[9] モバイルアプリのUI設計に大切な、7つの基本アニメーション …](https://photoshopvip.net/88490)
