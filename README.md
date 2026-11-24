# 발표콩이 🐰

학생별 발표 횟수를 기록하는 Windows GUI 앱입니다. 핑크 동물 테마로 학생 1–11번과 31–42번을 관리합니다.

## 실행

1. [Balpyokongi.zip](Balpyokongi.zip)을 내려받아 압축을 풉니다.
2. `Run-Balpyokongi.bat`을 더블 클릭합니다.
3. 학생 카드의 `+ 발표` 버튼으로 횟수를 올리고, `−` 버튼으로 잘못 입력한 횟수를 줄입니다.

창의 닫기(X)를 누르면 앱은 시스템 트레이로 숨습니다. 트레이 메뉴에서 다시 열거나 완전히 종료할 수 있습니다. 기록은 `%LOCALAPPDATA%\Balpyokongi\counts.json`에 저장됩니다.

## 파일

- `Balpyokongi.ps1`: GUI 프로그램
- `Run-Balpyokongi.bat`: 앱 실행
- `Balpyokongi.zip`: 바로 내려받아 실행할 수 있는 묶음

Windows PowerShell과 Windows Forms가 필요합니다. 추가 설치는 필요하지 않습니다.
