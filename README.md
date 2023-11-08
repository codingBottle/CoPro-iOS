# CoPro-iOS

<br>

## Code Convention

[https://github.com/StyleShare/swift-style-guide](https://github.com/StyleShare/swift-style-guide)

<br>

## Git Flow

1. 메인 레포에서 Fork 진행
   - 이후 Fork한 레포를 클론 받음
2. 메인 레포에서 이슈를 생성
   - 이슈 타이틀과 내용은 템플렛의 규정을 지킴
   - Title은 아래의 예시와 같이 커밋컨벤션을 참고하여 작성
     예시: [Setting] 프로젝트 초기 세팅을 진행합니다.
   - 본인 라벨 + 작업에 맞는 라벨을 등록
3. 클론 받은 로컬 main 브랜치에서 새로운 브랜치 생성
   - 브랜치 네임은 아래와 같이 커밋컨벤션 Prefix 이후 이슈번호를 같이 작성
     예시: Setting/#1
4. PR은 메인 레포에 develop 브랜치로 보낸다.
   - 이는 merge를 진행했을 때에 사고로 어플이 열리지 않는 불상사를 대비하기 위함

<br>

## Commit Convention

```markdown
[Feat]: 새로운 기능 구현
[Design]: just 화면. 레이아웃 조정
[Fix]: 버그, 오류 해결, 코드 수정
[Add]: Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 View 생성
[Del]: 쓸모없는 코드, 주석 삭제
[Refactor]: 전면 수정이 있을 때 사용합니다
[Remove]: 파일 삭제
[Chore]: 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
[Docs]: README나 WIKI 등의 문서 개정
[Comment]: 필요한 주석 추가 및 변경
[Setting]: 프로젝트 세팅
[Merge]: 머지
```

- 방식 : [Prefix] #이슈번호 - 내용작성
  - 예시 : [Setting] #1 - 프로젝트 폴더링
