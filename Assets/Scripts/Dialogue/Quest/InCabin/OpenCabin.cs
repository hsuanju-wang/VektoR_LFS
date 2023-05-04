using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class OpenCabin : Quest
{
    public override void StartQuest()
    {
        base.StartQuest();
        SceneManager.LoadScene("SpaceShip");
    }
}
